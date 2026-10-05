import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DiffFailureTests(unittest.TestCase):
    def test_diff_errors_bounds_and_cache_context(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            shutil.copytree(ROOT / "scripts", root / "scripts")
            runtime = root / "scripts/lib_runtime.sh"
            runtime.write_text(
                runtime.read_text(encoding="utf-8").replace(
                    "/var/home/VVgbon/Avalhla", tmp
                ),
                encoding="utf-8",
            )
            subprocess.run(["git", "init", "-q", tmp], check=True)
            source = root / "input.sh"
            source.write_text("echo fixture\n", encoding="utf-8")
            subprocess.run(["git", "-C", tmp, "add", "input.sh"], check=True)
            subprocess.run(
                [
                    "git",
                    "-C",
                    tmp,
                    "-c",
                    "user.name=Fixture",
                    "-c",
                    "user.email=fixture@example.invalid",
                    "commit",
                    "-qm",
                    "fixture",
                ],
                check=True,
            )
            bin_dir = root / "bin"
            bin_dir.mkdir()
            curl = bin_dir / "curl"
            curl.write_text(
                """#!/usr/bin/env python3
import json, os, sys
args = sys.argv[1:]
if "-d" in args:
    with open(os.environ["CAPTURE"], "w", encoding="utf-8") as stream:
        stream.write(args[args.index("-d") + 1])
    print(json.dumps({"response": "fixture"}))
else:
    print("{}")
""",
                encoding="utf-8",
            )
            curl.chmod(0o755)
            cache_dir = root / "reviewed"
            env = dict(
                os.environ,
                PATH=str(bin_dir) + ":" + os.environ["PATH"],
                AVA_REVIEWED_DIR=str(cache_dir),
                CAPTURE=str(root / "payload.json"),
            )
            result = subprocess.run(
                [
                    "bash",
                    str(root / "scripts/ava-diff"),
                    "input.sh",
                    "--since",
                    "not-a-real-commit",
                ],
                cwd=tmp,
                env=env,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertNotIn("(no git diff", result.stdout)
            self.assertNotIn("cache updated", result.stdout)
            self.assertFalse(list(cache_dir.glob("*.sha")) if cache_dir.exists() else [])

            source.write_text("x" * 50000 + "\n", encoding="utf-8")
            result = subprocess.run(
                [
                    "bash",
                    str(root / "scripts/ava-diff"),
                    "input.sh",
                    "--since",
                    "HEAD",
                    "--no-cache",
                ],
                cwd=tmp,
                env=env,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            payload = json.loads(
                (root / "payload.json").read_text(encoding="utf-8")
            )
            self.assertIn("untrusted-data", payload["prompt"])
            self.assertLess(len(payload["prompt"].encode()), 41024)

            subprocess.run(["git", "-C", tmp, "add", "input.sh"], check=True)
            subprocess.run(
                [
                    "git",
                    "-C",
                    tmp,
                    "-c",
                    "user.name=Fixture",
                    "-c",
                    "user.email=fixture@example.invalid",
                    "commit",
                    "-qm",
                    "large fixture",
                ],
                check=True,
            )
            first = subprocess.run(
                [
                    "bash",
                    str(root / "scripts/ava-diff"),
                    "input.sh",
                    "--since",
                    "HEAD",
                ],
                cwd=tmp,
                env=env,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(first.returncode, 0, first.stderr)
            self.assertIn("no model review required", first.stdout)
            (root / "payload.json").unlink(missing_ok=True)
            second = subprocess.run(
                [
                    "bash",
                    str(root / "scripts/ava-diff"),
                    "input.sh",
                    "--since",
                    "HEAD~1",
                ],
                cwd=tmp,
                env=env,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(second.returncode, 0, second.stderr)
            self.assertNotIn("unchanged since last review", second.stdout)
            self.assertTrue((root / "payload.json").is_file())


if __name__ == "__main__":
    unittest.main()
