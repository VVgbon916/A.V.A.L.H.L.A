from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class RedactionTests(unittest.TestCase):
    def redact(self, text):
        result = subprocess.run(
            ["bash", str(ROOT / "scripts/lib_redact.sh")],
            input=text,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def test_secret_removal_preserves_neighboring_data(self):
        cases = [
            ("Authorization: Bearer FAKE_BEARER_SECRET keep", "FAKE_BEARER_SECRET", "[REDACTED]"),
            ('curl -H "X-Api-Key: FAKE_HEADER_SECRET" https://example.invalid/', "FAKE_HEADER_SECRET", '" https://example.invalid/'),
            ('curl -H "Authorization: Token FAKE_SCHEME_SECRET" https://example.invalid/', "FAKE_SCHEME_SECRET", '" https://example.invalid/'),
            ("Authorization: Digest FAKE_AUTH_SECRET\nX-Trace: keep\n", "FAKE_AUTH_SECRET", "X-Trace: keep\n"),
            ("url?token=FAKE_QUERY_SECRET&next=keep", "FAKE_QUERY_SECRET", "&next=keep"),
            ("--token FAKE_FLAG_SECRET keep", "FAKE_FLAG_SECRET", " keep"),
            ("ghp_FAKE_GITHUB_TOKEN_MATERIAL keep", "FAKE_GITHUB_TOKEN_MATERIAL", " keep"),
        ]
        for source, secret, retained in cases:
            with self.subTest(source=source):
                output = self.redact(source)
                self.assertNotIn(secret, output)
                self.assertIn(retained, output)
                self.assertIn("[REDACTED]", output)

    def test_private_key_body_is_removed(self):
        output = self.redact(
            "before\n-----BEGIN PRIVATE KEY-----\nFAKE_KEY_BODY\n"
            "-----END PRIVATE KEY-----\nafter\n"
        )
        self.assertNotIn("FAKE_KEY_BODY", output)
        self.assertIn("before\n", output)
        self.assertIn("\nafter\n", output)

    def test_benign_names_and_short_strings_survive(self):
        text = "monkey=banana tokenization=example status=ok sk-short\n"
        self.assertEqual(self.redact(text), text)


if __name__ == "__main__":
    unittest.main()
