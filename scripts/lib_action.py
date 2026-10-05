"""Small, non-persistent Avalhla action-proposal boundary.

This module accepts one bounded Avalhla chat persona review-scope proposal
mapped to the existing LUX-instrumented DIFF workflow. It does not run the
review, choose tools, authorize operations, or write records or memory.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any


PERSONA_ABILITIES = {
    # Existing runtime persona; LUX remains the separate reviewer instrument.
    "avalhla-chat": {
        "review.capture_scope": "avalhla-door-diff",
    },
}

SKILL_PATHS = {
    "avalhla-door-diff": Path(".agents/skills/avalhla-door-diff/SKILL.md"),
}

PROPOSAL_FIELDS = {
    "schema_version",
    "action_id",
    "persona_id",
    "ability_id",
    "skill_id",
    "requested_operation",
    "target",
    "source_refs",
    "expected_output_type",
}
SOURCE_REF_FIELDS = {"source_class", "path", "sha256"}
OBJECT_FIELDS = {
    "schema_version",
    "object_type",
    "object_id",
    "producer_persona",
    "ability_id",
    "skill_id",
    "action_id",
    "source_refs",
    "derived_from",
    "content",
    "content_sha256",
    "integrity_status",
    "trust",
    "persistence_effect",
}


class ActionProposalError(ValueError):
    """A proposal failed deterministic validation."""


def _canonical_json(value: Any) -> bytes:
    return json.dumps(
        value, ensure_ascii=False, sort_keys=True, separators=(",", ":")
    ).encode("utf-8")


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _resolve_local_source(root: Path, relative: str) -> tuple[Path, str]:
    root = root.resolve(strict=True)
    supplied = Path(relative)
    if supplied.is_absolute() or ".." in supplied.parts or not supplied.parts:
        raise ActionProposalError("source path must be relative and traversal-free")
    if supplied.parts[0] != "docs" or supplied.suffix.lower() not in {".md", ".txt"}:
        raise ActionProposalError("source must be a Markdown or text file under docs/")

    candidate = root / supplied
    cursor = root
    for part in supplied.parts:
        cursor = cursor / part
        if cursor.is_symlink():
            raise ActionProposalError("symlink sources are not accepted")

    try:
        resolved = candidate.resolve(strict=True)
        resolved.relative_to(root)
    except (OSError, ValueError) as exc:
        raise ActionProposalError("source must resolve inside the repository") from exc

    if not resolved.is_file():
        raise ActionProposalError("source must be a regular file")
    raw = resolved.read_bytes()
    if len(raw) > 262144:
        raise ActionProposalError("source exceeds 262144 bytes")
    return resolved, _sha256(raw)


def validate_proposal(proposal: Any, root: Path) -> dict[str, Any]:
    """Validate an untrusted proposal and return its normalized form."""
    if not isinstance(proposal, dict):
        raise ActionProposalError("proposal must be a JSON object")
    if set(proposal) != PROPOSAL_FIELDS:
        missing = sorted(PROPOSAL_FIELDS - set(proposal))
        extra = sorted(set(proposal) - PROPOSAL_FIELDS)
        raise ActionProposalError(f"proposal fields differ; missing={missing}, extra={extra}")
    if type(proposal["schema_version"]) is not int or proposal["schema_version"] != 1:
        raise ActionProposalError("unsupported proposal schema_version")

    for key in ("action_id", "persona_id", "ability_id", "skill_id", "requested_operation", "target", "expected_output_type"):
        if not isinstance(proposal[key], str) or not proposal[key] or len(proposal[key]) > 160:
            raise ActionProposalError(f"{key} must be a non-empty bounded string")

    persona = proposal["persona_id"]
    ability = proposal["ability_id"]
    skill = proposal["skill_id"]
    if persona not in PERSONA_ABILITIES:
        raise ActionProposalError("unknown persona")
    expected_skill = PERSONA_ABILITIES[persona].get(ability)
    if expected_skill is None:
        raise ActionProposalError("unknown ability for persona")
    if skill != expected_skill:
        raise ActionProposalError("skill does not resolve from declared ability")

    root = root.resolve(strict=True)
    skill_path = root / SKILL_PATHS[skill]
    if not skill_path.is_file():
        raise ActionProposalError("referenced workflow skill is unavailable")

    if proposal["requested_operation"] != "capture_review_scope":
        raise ActionProposalError("operation is outside this bounded slice")
    if proposal["expected_output_type"] != "review_scope":
        raise ActionProposalError("unexpected output type")

    refs = proposal["source_refs"]
    if not isinstance(refs, list) or len(refs) != 1 or not isinstance(refs[0], dict):
        raise ActionProposalError("exactly one source reference is required")
    ref = refs[0]
    if set(ref) != SOURCE_REF_FIELDS:
        raise ActionProposalError("source reference fields are incomplete or unexpected")
    if ref["source_class"] != "LOCAL_AVALHLA" or ref["path"] != proposal["target"]:
        raise ActionProposalError("source reference must identify the local target")
    if not isinstance(ref["sha256"], str) or len(ref["sha256"]) != 64:
        raise ActionProposalError("source reference requires a SHA-256 digest")
    try:
        int(ref["sha256"], 16)
    except ValueError as exc:
        raise ActionProposalError("source reference digest is malformed") from exc

    _, actual_sha = _resolve_local_source(root, ref["path"])
    if actual_sha != ref["sha256"]:
        raise ActionProposalError("source reference digest does not match current bytes")

    return {
        **proposal,
        "source_refs": [{**ref}],
    }


def create_object(proposal: Any, root: Path) -> dict[str, Any]:
    """Return a deterministic, ephemeral result object; perform no persistence."""
    checked = validate_proposal(proposal, root)
    content = {
        "operation": checked["requested_operation"],
        "target": checked["target"],
    }
    content_sha = _sha256(_canonical_json(content))
    obj = {
        "schema_version": 1,
        "object_type": "review_scope",
        "object_id": "",
        "producer_persona": checked["persona_id"],
        "ability_id": checked["ability_id"],
        "skill_id": checked["skill_id"],
        "action_id": checked["action_id"],
        "source_refs": checked["source_refs"],
        "derived_from": [],
        "content": content,
        "content_sha256": content_sha,
        "integrity_status": "verified",
        "trust": "unverified",
        "persistence_effect": "NONE",
    }
    identity_payload = {key: value for key, value in obj.items() if key != "object_id"}
    obj["object_id"] = f"obj-sha256-{_sha256(_canonical_json(identity_payload))}"
    return obj


def verify_object(obj: Any) -> bool:
    """Check this object's exact shape and content digest, not its truth."""
    if not isinstance(obj, dict) or set(obj) != OBJECT_FIELDS:
        return False
    if type(obj.get("schema_version")) is not int or obj.get("schema_version") != 1 or obj.get("object_type") != "review_scope":
        return False
    if obj.get("trust") != "unverified" or obj.get("persistence_effect") != "NONE":
        return False
    if obj.get("integrity_status") != "verified":
        return False
    content = obj.get("content")
    if not isinstance(content, dict):
        return False
    if set(content) != {"operation", "target"} or content.get("operation") != "capture_review_scope":
        return False
    if not isinstance(content.get("target"), str):
        return False
    target = Path(content["target"])
    if (
        target.is_absolute()
        or ".." in target.parts
        or not target.parts
        or target.parts[0] != "docs"
        or target.suffix.lower() not in {".md", ".txt"}
    ):
        return False
    if not isinstance(obj.get("action_id"), str) or not obj["action_id"]:
        return False
    if obj.get("producer_persona") not in PERSONA_ABILITIES:
        return False
    if PERSONA_ABILITIES[obj["producer_persona"]].get(obj.get("ability_id")) != obj.get("skill_id"):
        return False
    refs = obj.get("source_refs")
    if not isinstance(refs, list) or len(refs) != 1 or not isinstance(refs[0], dict):
        return False
    if set(refs[0]) != SOURCE_REF_FIELDS or refs[0].get("source_class") != "LOCAL_AVALHLA":
        return False
    if refs[0].get("path") != content.get("target"):
        return False
    source_digest = refs[0].get("sha256")
    if not isinstance(source_digest, str) or len(source_digest) != 64:
        return False
    try:
        int(source_digest, 16)
    except ValueError:
        return False
    if obj.get("derived_from") != []:
        return False
    content_digest = _sha256(_canonical_json(content))
    identity_payload = {key: value for key, value in obj.items() if key != "object_id"}
    identity_digest = _sha256(_canonical_json(identity_payload))
    return (
        obj.get("content_sha256") == content_digest
        and obj.get("object_id") == f"obj-sha256-{identity_digest}"
    )
