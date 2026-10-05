#!/usr/bin/env python3
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/ava-github-review"
HEAD = "a" * 40
OTHER_HEAD = "b" * 40
FIELDS = "title,state,baseRefName,headRefName,headRefOid,url,reviewDecision"


class GitHubReviewTests(unittest.TestCase):
    def run_review(self, mode, synthesize=False):
        mock = r'''
gh() {
  case "$1 $2" in
    'repo view') printf 'owner/repo\n' ;;
    'pr view')
      if [[ "$*" == *"--json $FIELDS "* ]]; then
        printf 'SNAPSHOT_REQUEST\n' >> "$REQUEST_LOG"
        if [[ "$MODE" == failure ]]; then
          printf 'metadata unavailable\n' >&2
          return 42
        fi
        printf 'OPEN\nmain\nfeature\n%s\nhttps://example.invalid/pr/2\nREVIEW_REQUIRED\nTitle with spaces\nand another line\n' "$HEAD"
      elif [[ "$*" == *'--json headRefOid '* ]]; then
        printf 'HEAD_RECHECK\n' >> "$REQUEST_LOG"
        if [[ "$MODE" == changed ]]; then
          printf '%s\n' "$OTHER_HEAD"
        else
          printf '%s\n' "$HEAD"
        fi
      else
        printf 'Unexpected separate metadata request: %s\n' "$*" >&2
        return 43
      fi ;;
    'api --paginate')
      if [[ "$MODE" == many ]]; then
        for row in {1..12}; do
          printf 'CURRENT\\treviewer\\tCOMMENTED\\t%s\\tdate\\tfinding-%02d\\n' "$HEAD" "$row"
        done
      elif [[ "$MODE" == oversized ]]; then
        printf '%25001s\n' 'oversized evidence'
      fi ;;
    'pr checks') printf 'contract\tSUCCESS\tpass\n' ;;
    *) printf 'Unexpected request: %s\n' "$*" >&2; return 44 ;;
  esac
}
env() {
  while [[ "${1:-}" == *=* ]]; do
    shift
  done
  "$@"
}
python3() {
  if [[ "$*" == *'urllib.request'* ]]; then
    cat >"$SYNTH_LOG"
    printf '%s\n' '{"convergence":"INSUFFICIENT","material_findings":[],"evidence_gaps":["mock"],"smallest_next_gate":"current source"}'
  else
    command python3 "$@"
  fi
}
'''
        prefix = (
            f"MODE={mode}\nHEAD={HEAD}\nOTHER_HEAD={OTHER_HEAD}\n"
            f"FIELDS={FIELDS}\n"
        )
        with tempfile.TemporaryDirectory(prefix="ava-review-test-") as directory:
            log = Path(directory) / "requests"
            synth_log = Path(directory) / "synthesis"
            result = subprocess.run(
                ["bash", "-c", prefix + f"REQUEST_LOG={log}\nSYNTH_LOG={synth_log}\n" + mock
                 + SCRIPT.read_text(), "review-test", "2"]
                + (["--synthesize"] if synthesize else []),
                cwd=ROOT,
                text=True,
                capture_output=True,
            )
            requests = log.read_text() if log.exists() else ""
            if synth_log.exists():
                requests += "\nSYNTHESIS_INPUT\n" + synth_log.read_text()
            return result, requests

    def test_one_snapshot_and_stable_head(self):
        result, requests = self.run_review("stable")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(requests.count("SNAPSHOT_REQUEST"), 1)
        self.assertEqual(requests.count("HEAD_RECHECK"), 1)
        self.assertIn("Title with spaces\nand another line", result.stdout)
        self.assertIn(f"COMMIT    {HEAD}", result.stdout)
        self.assertIn("BASE      main", result.stdout)

    def test_changed_head_rejects_report(self):
        result, _ = self.run_review("changed")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("rerun the review", result.stderr)
        self.assertNotIn("01 WHERE", result.stdout)

    def test_metadata_failure_is_explicit(self):
        result, requests = self.run_review("failure")
        self.assertEqual(result.returncode, 42)
        self.assertIn("pull request metadata request failed", result.stderr)
        self.assertNotIn("HEAD_RECHECK", requests)
        self.assertNotIn("01 WHERE", result.stdout)

    def test_report_preserves_every_collected_row(self):
        result, _ = self.run_review("many")
        self.assertEqual(result.returncode, 0, result.stderr)
        for row in range(1, 13):
            self.assertIn(f"finding-{row:02d}", result.stdout)

    def test_synthesis_receives_every_evidence_section(self):
        result, requests = self.run_review("stable", synthesize=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("06 OLLAMA SYNTHESIS", result.stdout)
        for section in ("REVIEW_ROWS", "CR_INLINE", "DEVIN_INLINE",
                        "CR_SUMMARY", "DEVIN_SUMMARY", "CHECKS"):
            self.assertIn(section, requests)

    def test_oversized_synthesis_is_explicitly_refused(self):
        result, requests = self.run_review("oversized", synthesize=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("no sections were truncated or sent", result.stderr)
        self.assertNotIn("SYNTHESIS_INPUT", requests)


if __name__ == "__main__":
    unittest.main()
