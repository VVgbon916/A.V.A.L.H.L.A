#!/usr/bin/env python3
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import io
import os
import shutil
import time
import unittest
from unittest.mock import patch


SPEC = importlib.util.spec_from_file_location(
    "ava_team", Path(__file__).resolve().parents[1] / "scripts/ava-team.py")
TEAM = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(TEAM)


class TeamTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        (self.root / "docs").mkdir()
        (self.root / "docs/sample.md").write_text("Public example\n")
        subprocess.run(["git", "-C", str(self.root), "add", "."], check=True)
        subprocess.run(["git", "-C", str(self.root), "-c", "user.name=Test",
                        "-c", "user.email=test@example.invalid", "commit", "-qm",
                        "fixture"], check=True)

    def test_identity_includes_content_and_mode(self):
        first = TEAM.snapshot(self.root, ["docs/sample.md"])
        (self.root / "docs/sample.md").write_text("Changed public example\n")
        self.assertNotEqual(first, TEAM.snapshot(self.root, ["docs/sample.md"]))
        changed = TEAM.snapshot(self.root, ["docs/sample.md"])
        (self.root / "docs/sample.md").chmod(0o755)
        self.assertNotEqual(changed, TEAM.snapshot(self.root, ["docs/sample.md"]))

    def test_private_traversal_symlink_and_untracked_rejected(self):
        for name in ["../secret.txt", "/tmp/secret.txt", "memory/private.txt"]:
            with self.subTest(name=name), self.assertRaises(ValueError):
                TEAM.snapshot(self.root, [name])
        (self.root / "docs/untracked.md").write_text("Untracked")
        with self.assertRaises(subprocess.CalledProcessError):
            TEAM.snapshot(self.root, ["docs/untracked.md"])
        (self.root / "docs/link.md").symlink_to(self.root / "docs/sample.md")
        with self.assertRaises(ValueError):
            TEAM.snapshot(self.root, ["docs/link.md"])

    def test_no_truncation(self):
        with self.assertRaisesRegex(ValueError, "No truncation"):
            TEAM.snapshot(self.root, ["docs/sample.md"], limit=1)

    def test_review_cache_and_corruption(self):
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        cache = self.root / "cache"
        response = subprocess.CompletedProcess([], 0,
                   json.dumps({"result": "No observed defect.", "is_error": False}), "")
        with patch.object(TEAM.subprocess, "run", return_value=response) as call:
            first = TEAM.review(bundle, "proof", "test", "v1", cache, 1)
            second = TEAM.review(bundle, "proof", "test", "v1", cache, 1)
            self.assertEqual(call.call_count, 1)
            self.assertFalse(first["cache_hit"])
            self.assertTrue(second["cache_hit"])
            self.assertIn("--tools", call.call_args.args[0])
        path = next(cache.glob("*.json"))
        saved = json.loads(path.read_text())
        saved["result"] = "Tampered"
        path.write_text(json.dumps(saved))
        with self.assertRaisesRegex(ValueError, "integrity mismatch"):
            TEAM.review(bundle, "proof", "test", "v1", cache, 1)
        del saved["result"]
        path.write_text(json.dumps(saved))
        with self.assertRaisesRegex(ValueError, "integrity mismatch"):
            TEAM.review(bundle, "proof", "test", "v1", cache, 1)
        path.write_text("[]")
        with self.assertRaisesRegex(ValueError, "integrity mismatch"):
            TEAM.review(bundle, "proof", "test", "v1", cache, 1)

    def test_provider_failures_never_cached(self):
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        for response in [
            subprocess.CompletedProcess([], 1, "", "failed"),
            subprocess.CompletedProcess([], 0, '{"is_error":true,"result":"error"}', ""),
            subprocess.CompletedProcess([], 0, '{"result":""}', ""),
        ]:
            with patch.object(TEAM.subprocess, "run", return_value=response):
                with self.assertRaises((ValueError, RuntimeError)):
                    TEAM.review(bundle, "proof", "test", "v1", self.root / "cache", 1)
        self.assertFalse((self.root / "cache").exists())

    def test_request_identity_and_scheduling(self):
        self.assertEqual(len(TEAM.PROFILES["slow"]), 1)
        self.assertEqual(len(TEAM.PROFILES["normal"]), 2)
        self.assertEqual(TEAM.PROFILES["normal"], TEAM.PROFILES["fast"])
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        response = subprocess.CompletedProcess([], 0, '{"result":"Evidence only."}', "")
        with patch.object(TEAM.subprocess, "run", return_value=response) as call:
            for quest, version in [("first", "v1"), ("second", "v1"), ("second", "v2")]:
                TEAM.review(bundle, "proof", quest, version, self.root / "cache", 1)
            self.assertEqual(call.call_count, 3)

    def test_local_provider_and_failure(self):
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        reply = io.BytesIO(b'{"done":true,"message":{"content":"Local evidence."}}')
        with patch.object(TEAM.urllib.request, "urlopen", return_value=reply) as call:
            result = TEAM.review(bundle, "proof", "local", "digest", self.root / "cache",
                                 1, provider="ollama", model="existing:latest")
            self.assertEqual(result["result"], "Local evidence.")
            request = call.call_args.args[0]
            self.assertEqual(request.full_url, "http://127.0.0.1:11434/api/chat")
            self.assertEqual(json.loads(request.data)["options"]["num_predict"], 512)
        with patch.object(TEAM.urllib.request, "urlopen",
                          return_value=io.BytesIO(b'{"done":false}')):
            with self.assertRaisesRegex(ValueError, "incomplete"):
                TEAM.review(bundle, "proof", "incomplete", "digest", self.root / "cache",
                            1, provider="ollama", model="existing:latest")

    def test_scope_mutation_and_permission(self):
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        (self.root / "docs/sample.md").write_text("Changed after collection.\n")
        self.assertNotEqual(bundle, TEAM.snapshot(self.root, ["docs/sample.md"]))
        with patch.object(TEAM, "snapshot", return_value=bundle), \
                patch.object(TEAM, "review") as provider, \
                patch.object(TEAM.sys, "argv", ["ava-team.py", "run", "--quest", "test",
                                              "--files", "docs/sample.md"]), \
                patch.object(TEAM.sys, "stderr", io.StringIO()):
            with self.assertRaises(SystemExit) as raised:
                TEAM.main()
            self.assertEqual(raised.exception.code, 2)
            provider.assert_not_called()

    def test_moving_capture_and_review_rejected(self):
        with patch.object(Path, "read_bytes", side_effect=[b"before", b"after"]):
            with self.assertRaisesRegex(ValueError, "capture"):
                TEAM.snapshot(self.root, ["docs/sample.md"])
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        args = ["ava-team.py", "run", "--quest", "test", "--files",
                "docs/sample.md", "--send-public"]
        with patch.object(TEAM.sys, "argv", args), \
                patch.object(TEAM, "provider_identity", return_value="version"), \
                patch.object(TEAM, "review", return_value={}), \
                patch.object(TEAM, "snapshot", side_effect=[bundle, {**bundle, "head": "changed"}]):
            with self.assertRaisesRegex(ValueError, "Source changed during review"):
                TEAM.main()
        with patch.object(TEAM.sys, "argv", args), \
                patch.object(TEAM, "provider_identity", side_effect=["before", "after"]), \
                patch.object(TEAM, "review", return_value={}), \
                patch.object(TEAM, "snapshot", return_value=bundle):
            with self.assertRaisesRegex(ValueError, "Provider changed during review"):
                TEAM.main()

    @unittest.skipUnless(shutil.which("tmux"), "tmux not installed")
    def test_persistent_launch_in_isolated_server(self):
        real_tmux = shutil.which("tmux")
        socket = str(self.root / "owned-tmux.sock")
        wrapper = self.root / "bin"
        wrapper.mkdir()
        shim = wrapper / "tmux"
        shim.write_text("#!/bin/sh\nexec " + TEAM.shlex.join(
            [real_tmux, "-S", socket, "-f", "/dev/null"]) + ' "$@"\n')
        shim.chmod(0o700)
        bundle = TEAM.snapshot(self.root, ["docs/sample.md"])
        session = "ava-team-" + TEAM.digest(TEAM.encoded(bundle))[:12]
        sentinel = self.root / "must-not-exist"
        argument = "; touch " + str(sentinel)
        env = {"PATH": str(wrapper) + os.pathsep + os.environ["PATH"]}
        try:
            with patch.dict(os.environ, env):
                TEAM.launch_console(self.root, [TEAM.sys.executable, "-c",
                    "import sys; print('PERSISTED:' + sys.argv[1])", argument], bundle)
            for _ in range(100):
                dead = subprocess.check_output(
                    [real_tmux, "-S", socket, "display-message", "-p", "-t", session,
                     "#{pane_dead}"]).decode().strip()
                output = subprocess.check_output(
                    [real_tmux, "-S", socket, "capture-pane", "-p", "-S", "-",
                     "-t", session]).decode()
                if dead == "1" and "PERSISTED:" + argument in output:
                    break
                time.sleep(0.05)
            self.assertEqual(dead, "1")
            self.assertIn("PERSISTED:" + argument, output)
            self.assertFalse(sentinel.exists())
        finally:
            subprocess.run([real_tmux, "-S", socket, "kill-server"],
                           check=False, capture_output=True)


if __name__ == "__main__":
    unittest.main()
