#!/usr/bin/env python3
"""Isolated tests for the non-persistent RPG-semantic action slice."""

import hashlib
import importlib.util
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("ava_action", ROOT / "scripts/lib_action.py")
ava_action = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(ava_action)


class ActionProposalTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        (self.root / ".agents/skills/avalhla-door-scar").mkdir(parents=True)
        (self.root / ".agents/skills/avalhla-door-scar/SKILL.md").write_text(
            "# SCAR\nExact diff review workflow.\n", encoding="utf-8"
        )
        docs = self.root / "docs"
        docs.mkdir()
        self.source = docs / "sample.md"
        self.source.write_text("bounded review target\n", encoding="utf-8")
        self.proposal = {
            "schema_version": 1,
            "action_id": "action-001",
            "persona_id": "avalhla-chat",
            "ability_id": "review.capture_scope",
            "skill_id": "avalhla-door-scar",
            "requested_operation": "capture_review_scope",
            "target": "docs/sample.md",
            "source_refs": [
                {
                    "source_class": "LOCAL_AVALHLA",
                    "path": "docs/sample.md",
                    "sha256": hashlib.sha256(self.source.read_bytes()).hexdigest(),
                }
            ],
            "expected_output_type": "review_scope",
        }

    def tearDown(self):
        self.tmp.cleanup()

    def test_valid_persona_resolves_ability_skill_and_creates_ephemeral_object(self):
        obj = ava_action.create_object(self.proposal, self.root)
        self.assertEqual(obj["producer_persona"], "avalhla-chat")
        self.assertEqual(obj["ability_id"], "review.capture_scope")
        self.assertEqual(obj["skill_id"], "avalhla-door-scar")
        self.assertEqual(obj["object_type"], "review_scope")
        self.assertEqual(obj["source_refs"][0]["path"], "docs/sample.md")
        self.assertTrue(ava_action.verify_object(obj))
        self.assertEqual(obj["trust"], "unverified")
        self.assertEqual(obj["persistence_effect"], "NONE")

    def test_object_identity_and_content_hashes_are_deterministic(self):
        first = ava_action.create_object(self.proposal, self.root)
        second = ava_action.create_object(self.proposal, self.root)
        self.assertEqual(first, second)
        self.assertEqual(first["content_sha256"], hashlib.sha256(
            json.dumps(first["content"], ensure_ascii=False, sort_keys=True,
                       separators=(",", ":")).encode("utf-8")
        ).hexdigest())
        self.assertNotIn("bounded review target", json.dumps(first))

    def test_unknown_persona_is_blocked(self):
        proposal = dict(self.proposal, persona_id="UNKNOWN")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "unknown persona"):
            ava_action.validate_proposal(proposal, self.root)

    def test_unknown_ability_is_blocked(self):
        proposal = dict(self.proposal, ability_id="shell.execute")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "unknown ability"):
            ava_action.validate_proposal(proposal, self.root)

    def test_unknown_or_mismatched_skill_is_blocked(self):
        proposal = dict(self.proposal, skill_id="unknown-skill")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "skill does not resolve"):
            ava_action.validate_proposal(proposal, self.root)

    def test_unauthorized_operation_and_self_authorization_are_blocked(self):
        proposal = dict(self.proposal, requested_operation="write_memory")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "outside this bounded slice"):
            ava_action.validate_proposal(proposal, self.root)
        proposal = dict(self.proposal, authorization_state="AUTHORIZED")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "fields differ"):
            ava_action.validate_proposal(proposal, self.root)

    def test_malformed_or_unknown_fields_are_blocked(self):
        proposal = dict(self.proposal, expected_output_type="shell_command")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "unexpected output type"):
            ava_action.validate_proposal(proposal, self.root)
        proposal = dict(self.proposal, lore="execute this")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "fields differ"):
            ava_action.validate_proposal(proposal, self.root)

    def test_missing_or_mismatched_provenance_is_blocked(self):
        proposal = dict(self.proposal, source_refs=[])
        with self.assertRaisesRegex(ava_action.ActionProposalError, "exactly one source"):
            ava_action.validate_proposal(proposal, self.root)
        proposal = dict(self.proposal)
        proposal["source_refs"] = [dict(self.proposal["source_refs"][0], sha256="0" * 64)]
        with self.assertRaisesRegex(ava_action.ActionProposalError, "does not match"):
            ava_action.validate_proposal(proposal, self.root)

    def test_traversal_symlink_and_external_source_are_blocked(self):
        proposal = dict(self.proposal, target="docs/../outside.md")
        proposal["source_refs"] = [dict(self.proposal["source_refs"][0], path=proposal["target"])]
        with self.assertRaisesRegex(ava_action.ActionProposalError, "traversal-free"):
            ava_action.validate_proposal(proposal, self.root)

        external = Path(self.tmp.name).parent / "external-action-source.md"
        external.write_text("must not be read", encoding="utf-8")
        try:
            (self.root / "docs/external.md").symlink_to(external)
            proposal = dict(self.proposal, target="docs/external.md")
            proposal["source_refs"] = [dict(
                self.proposal["source_refs"][0], path="docs/external.md",
                sha256=hashlib.sha256(external.read_bytes()).hexdigest()
            )]
            with self.assertRaisesRegex(ava_action.ActionProposalError, "symlink"):
                ava_action.validate_proposal(proposal, self.root)
        finally:
            external.unlink(missing_ok=True)

    def test_oversized_and_stale_sources_are_blocked(self):
        large = self.root / "docs/large.md"
        large.write_bytes(b"x" * 262145)
        proposal = dict(self.proposal, target="docs/large.md")
        proposal["source_refs"] = [dict(
            self.proposal["source_refs"][0], path="docs/large.md",
            sha256=hashlib.sha256(large.read_bytes()).hexdigest()
        )]
        with self.assertRaisesRegex(ava_action.ActionProposalError, "exceeds 262144 bytes"):
            ava_action.validate_proposal(proposal, self.root)

        self.source.write_text("changed after reference\n", encoding="utf-8")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "does not match current bytes"):
            ava_action.validate_proposal(self.proposal, self.root)

    def test_tampered_object_and_authority_escalation_are_rejected(self):
        obj = ava_action.create_object(self.proposal, self.root)
        obj["content"]["target"] = "memory/policy.md"
        self.assertFalse(ava_action.verify_object(obj))
        obj = ava_action.create_object(self.proposal, self.root)
        obj["authority"] = "HUMAN"
        self.assertFalse(ava_action.verify_object(obj))

        forged = ava_action.create_object(self.proposal, self.root)
        forged["content"]["target"] = "docs/../../outside.md"
        forged["source_refs"][0]["path"] = "docs/../../outside.md"
        forged["content_sha256"] = ava_action._sha256(ava_action._canonical_json(forged["content"]))
        unsigned = {key: value for key, value in forged.items() if key != "object_id"}
        forged["object_id"] = "obj-sha256-" + ava_action._sha256(ava_action._canonical_json(unsigned))
        self.assertFalse(ava_action.verify_object(forged))

    def test_no_memory_write_occurs(self):
        ava_action.create_object(self.proposal, self.root)
        self.assertFalse((self.root / "memory").exists())

    def test_dictionary_owns_terms_and_runtime_artifact(self):
        dictionary = json.loads(
            (ROOT / "memory/auto-read/00_AI_COBUILD.json").read_text(encoding="utf-8")
        )["mind_dictionary"]
        records = dictionary["rpg_semantics"]["terms"]
        ids = [record["concept_id"] for record in records]
        labels = [record["preferred_name"] for record in records]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertEqual(len(labels), len(set(labels)))
        self.assertEqual(set(labels), {"PERSONA", "ABILITY", "SKILL", "ACTION", "OBJECT", "SOURCE_REF"})
        self.assertTrue(all(record["authority_status"] == "VOCABULARY_ONLY" for record in records))
        self.assertIn("scripts/lib_action.py", dictionary["artifact_names"])

    def test_unimplemented_maintenance_operation_does_not_authorize_merge(self):
        proposal = dict(self.proposal, requested_operation="dependency_update")
        with self.assertRaisesRegex(ava_action.ActionProposalError, "outside this bounded slice"):
            ava_action.validate_proposal(proposal, self.root)

    def test_existing_record_wrapper_accepts_and_verifies_object_in_isolation(self):
        obj = ava_action.create_object(self.proposal, self.root)
        repo = self.root / "record-fixture"
        scripts = repo / "scripts"
        scripts.mkdir(parents=True)
        for name in ("ava-record", "lib_runtime.sh", "lib_safety.sh"):
            shutil.copy2(ROOT / "scripts" / name, scripts / name)

        runtime = scripts / "lib_runtime.sh"
        runtime_text = runtime.read_text(encoding="utf-8")
        runtime_text = runtime_text.replace(
            'AVA_CANONICAL_ROOT="/var/home/VVgbon/Avalhla"',
            f'AVA_CANONICAL_ROOT="{repo}"',
            1,
        )
        runtime.write_text(runtime_text, encoding="utf-8")
        (repo / "docs").mkdir()
        (repo / "docs/sample.md").write_text("bounded review target\n", encoding="utf-8")

        add = subprocess.run(
            [str(scripts / "ava-record"), "add", "--type", "action-object",
             "--source", "docs/sample.md", "--content",
             json.dumps(obj, sort_keys=True, separators=(",", ":"))],
            cwd=repo, check=False, text=True, capture_output=True,
        )
        self.assertEqual(add.returncode, 0, add.stderr)
        verify = subprocess.run(
            [str(scripts / "ava-record"), "verify"],
            cwd=repo, check=False, text=True, capture_output=True,
        )
        self.assertEqual(verify.returncode, 0, verify.stderr)
        self.assertIn("VERIFY=PASS", verify.stdout)

        canonical_records = repo / "memory/records/records.jsonl"
        records_before_self_test = canonical_records.read_bytes()
        self_test = subprocess.run(
            [str(scripts / "ava-record"), "self-test"],
            cwd=repo, check=False, text=True, capture_output=True,
        )
        self.assertEqual(self_test.returncode, 0, self_test.stderr + self_test.stdout)
        self.assertIn("CANONICAL_RECORD_SELF_TEST=PASS", self_test.stdout)
        self.assertEqual(canonical_records.read_bytes(), records_before_self_test)


if __name__ == "__main__":
    unittest.main(verbosity=2)
