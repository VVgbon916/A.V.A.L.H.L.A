#!/usr/bin/env python3
"""Canonical naming and isolated SIGNAL prompt contracts."""
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "config/zsh/avalhla.zsh-theme"
DOORS = ["ORIENT", "TRACE", "BOUNDARY", "INSPECT", "STRIKE", "DIFF", "REPRISE", "LANTERN"]


class DesignTests(unittest.TestCase):
    def test_canonical_names_and_unchanged_instruments(self):
        registry = json.loads((ROOT / "config/avalhla-naming.v1.json").read_text())
        self.assertEqual([row["door"] for row in registry["doors"]], DOORS)
        self.assertEqual([row["skill"] for row in registry["doors"]],
                         [f"avalhla-door-{name.lower()}" for name in DOORS])
        self.assertEqual([row["instrument"] for row in registry["doors"]],
                         ["WITNESS", "WITNESS", "LUX", "WITNESS", "VEX", "LUX", "ECHO", "LUX + VEX"])
        self.assertEqual(registry["new_finding_rule"]["name"], "RETURN_TO_STRIKE")
        self.assertTrue((ROOT / "references/RETURN_TO_STRIKE.md").is_file())
        self.assertFalse((ROOT / "references/RETURN_TO_FANG.md").exists())
        activation = (ROOT / "docs/DOOR_ACTIVATION.md").read_text()
        self.assertNotIn("\nDAWA\n", activation)
        self.assertIn("Dawa is not a ninth door", activation)
        self.assertNotIn("STOP AT THE THRESHOLD", (ROOT / "scripts/ava-weave").read_text())
        for name in DOORS:
            self.assertIn(name, activation)

    def test_chat_signature_has_no_suffix(self):
        lines = (ROOT / "persona/avalhla-chat.Modelfile").read_text().splitlines()
        self.assertIn("Dawa <---- AvvA ----> Avalhla", lines)
        self.assertFalse(any("(^.-)" in line for line in lines))

    @unittest.skipUnless(shutil.which("zsh"), "Zsh unavailable; structural contracts still run")
    def test_signal_rendering_and_git_context(self):
        with tempfile.TemporaryDirectory(prefix="signal-test-") as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q", "-b", "signal-test", directory], check=True)
            script = '''
source "$1"
true
print -P -- "$PROMPT"
false
print -P -- "$PROMPT"
print -r -- "RIGHT=$RPROMPT"
'''
            result = subprocess.run(["zsh", "-f", "-c", script, "test", str(THEME)],
                                    cwd=root, capture_output=True, text=True, check=True)
            import re
            text = re.sub(r"\x1b\[[0-9;]*m", "", result.stdout)
            self.assertEqual(text.count("Dawa <---- AvvA ----> Avalhla"), 2)
            self.assertIn("git:(signal-test)", text)
            self.assertIn("exit 1", text)
            self.assertEqual(text.count("exit 1"), 1)
            self.assertIn("RIGHT=\n", text)
            self.assertNotIn("(^.-)", text)
            self.assertNotIn("_ava_mood_dot", THEME.read_text())
            for filename in (THEME, ROOT / "config/zshrc.example"):
                subprocess.run(["zsh", "-n", str(filename)], check=True)

    @unittest.skipUnless(shutil.which("zsh"), "Zsh unavailable")
    def test_non_repository_and_percent_branch(self):
        with tempfile.TemporaryDirectory(prefix="signal-test-") as directory:
            script = 'source "$1"; print -P -- "$PROMPT"'
            result = subprocess.run(["zsh", "-f", "-c", script, "test", str(THEME)],
                                    cwd=directory, capture_output=True, text=True, check=True)
            self.assertNotIn("git:(", result.stdout)
            subprocess.run(["git", "init", "-q", "-b", "percent%F{red}", directory], check=True)
            result = subprocess.run(["zsh", "-f", "-c", script, "test", str(THEME)],
                                    cwd=directory, capture_output=True, text=True, check=True)
            self.assertIn("git:(percent%F{red})", result.stdout)


if __name__ == "__main__":
    unittest.main()
