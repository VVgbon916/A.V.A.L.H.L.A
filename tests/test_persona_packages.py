"""Regression checks for the package guidance changed in PR #7.

Run from the repository root with:
    python3 -B -m unittest discover -s tests -p 'test_persona_packages.py'
"""

from pathlib import Path
import re
import unittest


PERSONA_DIR = Path(__file__).resolve().parents[1] / "persona"
EXPECTED_PACKAGES = ("coolercontrol", "mangohud", "topgrade", "gh")


class PersonaPackageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.system_prompt = (PERSONA_DIR / "system-prompt.txt").read_text(
            encoding="utf-8"
        )
        cls.profile_example = (PERSONA_DIR / "user-profile.txt.example").read_text(
            encoding="utf-8"
        )

    def test_system_prompt_retains_exactly_the_supported_layered_packages(self):
        lists = re.findall(
            r"Layered packages are\s+limited to:\s*([^\.]+)\.",
            self.system_prompt,
        )
        self.assertEqual(len(lists), 1, "Expected one layered-package allowlist")
        packages = [item.strip().strip("`") for item in lists[0].split(",")]

        # Ignore ordering while rejecting missing, extra, or duplicate packages.
        self.assertCountEqual(packages, EXPECTED_PACKAGES)

    def test_profile_example_retains_exactly_the_supported_layered_packages(self):
        sections = re.findall(
            r"^### Layered packages \(rpm-ostree\)[ \t]*\n"
            r"(.*?)(?=^### |\Z)",
            self.profile_example,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertEqual(len(sections), 1, "Expected one layered-packages section")
        examples = re.findall(
            r"<list only what's actually layered,\s*e\.g\.\s*([^>]+)>",
            sections[0],
        )
        self.assertEqual(len(examples), 1, "Expected one layered-package example")
        packages = [item.strip() for item in examples[0].split(",")]

        self.assertCountEqual(packages, EXPECTED_PACKAGES)

    def test_system_prompt_does_not_reintroduce_liquidctl(self):
        # Check the whole prompt so a second recommendation cannot bypass the list.
        self.assertNotRegex(self.system_prompt, re.compile(r"\bliquidctl\b", re.I))

    def test_profile_example_does_not_reintroduce_liquidctl(self):
        self.assertNotRegex(self.profile_example, re.compile(r"\bliquidctl\b", re.I))


if __name__ == "__main__":
    unittest.main()
