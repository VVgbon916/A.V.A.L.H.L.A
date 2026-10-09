"""Behavioral ranking contract; synthetic JSONL only, no session writes."""

import json
from pathlib import Path
import subprocess
import unittest


RANKER = Path(__file__).resolve().parents[1] / "scripts" / "ava-context"


def rank(query, users):
    rows = []
    for user in users:
        rows.extend((
            {"role": "user", "content": user},
            {"role": "assistant", "content": "reply"},
        ))
    return subprocess.run(
        ["bash", str(RANKER), query, "1"],
        input="".join(json.dumps(row) + "\n" for row in rows),
        text=True, capture_output=True, timeout=10,
    )


class ContextRankingTests(unittest.TestCase):
    def assert_selected(self, query, users, expected):
        result = rank(query, users)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(
            result.stdout == f"user: {expected}\nassistant: reply\n\n",
            f"query={query!r}: expected {expected!r}; "
            f"received prefix={result.stdout[:120]!r}",
        )

    def test_relevant_equal_length_content_beats_unrelated(self):
        relevant, unrelated = "nebula signal", "quartz signal"
        self.assertEqual(len(relevant), len(unrelated))
        for users in ([relevant, unrelated], [unrelated, relevant]):
            with self.subTest(users=users):
                self.assert_selected("nebula", users, relevant)

    def test_changing_query_changes_selected_turn(self):
        users = ["nebula signal", "quartz signal"]
        for query, expected in zip(("nebula", "quartz"), users):
            with self.subTest(query=query):
                self.assert_selected(query, users, expected)

    def test_newer_equal_relevance_content_beats_older(self):
        older, newer = "nebula oldest", "nebula newest"
        self.assertEqual(len(older), len(newer))
        self.assert_selected("nebula", [older, newer], newer)

    def test_unrelated_padding_cannot_dominate_relevance(self):
        relevant = "nebula signal"
        padded = "quartz " + "x" * 1_000_000
        self.assert_selected("nebula", [relevant, padded], relevant)


if __name__ == "__main__":
    unittest.main(verbosity=2)
