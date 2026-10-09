import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class CaptureTests(unittest.TestCase):
    def run_review(self, changed=False, missing_field=""):
        with tempfile.TemporaryDirectory() as tmp:
            fake_gh = Path(tmp) / "gh"
            fake_gh.write_text(
                """#!/usr/bin/env python3
import json, os, sys
args = sys.argv[1:]
if args[:2] == ["repo", "view"]:
    print("VVgbon916/A.V.A.L.H.L.A")
elif args[:2] == ["pr", "view"]:
    fields = args[args.index("--json") + 1]
    if fields == "headRefOid":
        print(("b" if os.environ["CHANGED"] == "1" else "a") * 40)
    elif "," in fields:
        metadata = dict(
            title="fixture", state="OPEN", baseRefName="main",
            headRefName="worker", headRefOid="a" * 40,
            url="https://example.invalid", reviewDecision="REVIEW_REQUIRED"
        )
        metadata.pop(os.environ["MISSING_FIELD"], None)
        print(json.dumps(metadata))
    else:
        print("metadata must be captured atomically", file=sys.stderr)
        sys.exit(3)
elif args[:2] == ["pr", "checks"]:
    pass
elif args[0] == "api":
    print("HISTORICAL\\tfixture\\t1\\t" + "c" * 40 + "\\tuntrusted")
else:
    sys.exit(2)
""",
                encoding="utf-8",
            )
            fake_gh.chmod(0o755)
            env = dict(
                os.environ,
                PATH=tmp + ":" + os.environ["PATH"],
                CHANGED=str(int(changed)),
                MISSING_FIELD=missing_field,
            )
            return subprocess.run(
                ["bash", str(ROOT / "scripts/ava-github-review"), "2"],
                env=env,
                text=True,
                capture_output=True,
                cwd=ROOT,
                check=False,
            )

    def test_consistent_metadata_and_old_evidence(self):
        result = self.run_review()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("HISTORICAL", result.stdout)
        self.assertIn("a" * 40, result.stdout)

    def test_changed_head_refuses_report(self):
        result = self.run_review(changed=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("head changed", result.stderr)
        self.assertNotIn("01 WHERE", result.stdout)

    def test_missing_metadata_field_refuses_report(self):
        result = self.run_review(missing_field="headRefOid")
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("01 WHERE", result.stdout)


if __name__ == "__main__":
    unittest.main()
