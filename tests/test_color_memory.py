#!/usr/bin/env python3
import hashlib
import importlib.util
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("color_memory", ROOT / "scripts/lib_color_memory.py")
HASHING = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(HASHING)


class ColorMemoryTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="ava-color-memory-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name) / "root"
        scripts = self.root / "scripts"
        scripts.mkdir(parents=True)
        for name in ("ava-color-memory", "lib_color_memory.py", "lib_runtime.sh"):
            shutil.copy2(ROOT / "scripts" / name, scripts / name)
        runtime = scripts / "lib_runtime.sh"
        runtime.write_text(runtime.read_text().replace("/var/home/VVgbon/Avalhla", str(self.root)))
        config = self.root / "config/color"
        config.mkdir(parents=True)
        shutil.copy2(ROOT / "config/color/avalhla-color-field.v1.json", config)
        self.door = scripts / "ava-color-memory"
        self.collection = self.root / "collection"
        self.collection.mkdir()
        self.file = self.collection / "a.txt"
        self.file.write_bytes(b"hello\n")

    def run_door(self, *args, input=None):
        return subprocess.run(["bash", str(self.door), *map(str, args)], cwd=self.root,
                              input=input, text=True, capture_output=True,
                              env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"})

    def assert_record(self, result, expected_hash, families):
        self.assertEqual(result.returncode, 0, result.stderr)
        output = json.loads(result.stdout)
        source = output["source_ash"]
        self.assertEqual(source["sha256"], expected_hash)
        self.assertEqual(source["color"], "#" + expected_hash[:6].upper())
        self.assertEqual(source["rgb"], [int(expected_hash[i:i + 2], 16) for i in (0, 2, 4)])
        self.assertEqual(source["families"], families)
        record = {"schema": output["schema"], "source_ash": source}
        canonical = json.dumps(record, ensure_ascii=False, sort_keys=True,
                               separators=(",", ":")).encode("utf-8")
        self.assertEqual(output["record_ash"]["sha256"], hashlib.sha256(canonical).hexdigest())

    def test_file_and_stdin_exact_bytes_and_record_identity(self):
        expected = hashlib.sha256(b"hello\n").hexdigest()
        self.assert_record(self.run_door("file", self.file, "orange,blue"), expected, ["orange", "blue"])
        self.assert_record(self.run_door("stdin", input="hello\n"), expected, [])

    def test_directory_sorted_manifest_and_renames(self):
        second = self.collection / "z.txt"
        second.write_bytes(b"other")
        manifest = [{"path": "a.txt", "sha256": hashlib.sha256(b"hello\n").hexdigest()},
                    {"path": "z.txt", "sha256": hashlib.sha256(b"other").hexdigest()}]
        expected = hashlib.sha256((json.dumps(manifest, sort_keys=True,
                                              separators=(",", ":")) + "\n").encode()).hexdigest()
        self.assert_record(self.run_door("dir", self.collection, "green"), expected, ["green"])
        second.rename(self.collection / "b.txt")
        result = self.run_door("dir", self.collection)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotEqual(json.loads(result.stdout)["source_ash"]["sha256"], expected)

    def test_unknown_duplicate_and_malformed_families(self):
        for families in ("unknown", "orange,orange", "orange,,blue",
                         "orange,blue,green,red", "blue!"):
            with self.subTest(families=families):
                result = self.run_door("file", self.file, families)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")

    def test_root_escapes_and_traversal(self):
        outside = Path(self.temporary.name) / "outside.txt"
        outside.write_text("outside")
        for source in (outside, self.collection / "../collection/a.txt"):
            result = self.run_door("file", source)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(result.stdout, "")

    def test_direct_and_nested_symlinks(self):
        (self.collection / "link").symlink_to(self.file)
        self.assertNotEqual(self.run_door("dir", self.collection).returncode, 0)
        (self.root / "alias").symlink_to(self.collection, target_is_directory=True)
        for kind, source in (("file", self.root / "alias/a.txt"),
                             ("dir", self.root / "alias"),
                             ("file", self.collection / "link")):
            result = self.run_door(kind, source)
            self.assertNotEqual(result.returncode, 0)
        (self.collection / "link").unlink()
        nested = self.collection / "nested"
        nested.mkdir()
        (nested / "outside").symlink_to(Path(self.temporary.name), target_is_directory=True)
        self.assertNotEqual(self.run_door("dir", self.collection).returncode, 0)

    def test_collection_membership_and_content_mutation(self):
        original = HASHING.hash_file
        for mutation in ("add", "content"):
            mutated = False

            def changing_hash(path):
                nonlocal mutated
                result = original(path)
                if not mutated:
                    mutated = True
                    if mutation == "add":
                        (self.collection / "new.txt").write_text("new")
                    else:
                        self.file.write_text("changed bytes")
                return result

            with self.subTest(mutation=mutation), patch.object(HASHING, "hash_file", changing_hash):
                with self.assertRaisesRegex(ValueError, "changed"):
                    HASHING.source_hash(self.root, "directory", self.collection)
            (self.collection / "new.txt").unlink(missing_ok=True)
            self.file.write_bytes(b"hello\n")


if __name__ == "__main__":
    unittest.main()
