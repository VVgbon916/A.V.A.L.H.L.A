#!/usr/bin/env bash
# Shared reader/validator for the one computable Avalhla Color Field source.
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
COLOR_FIELD_FILE="${AVA_COLOR_FIELD_FILE:-$ROOT/config/color/avalhla-color-field.v1.json}"

ava_color_field_file() {
    printf '%s\n' "$COLOR_FIELD_FILE"
}

ava_color_field_validate() {
    python3 - "$COLOR_FIELD_FILE" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
doc = json.loads(path.read_text(encoding="utf-8"))

def require(actual, expected, label):
    def same_type_value(left, right):
        if type(left) is not type(right):
            return False
        if isinstance(right, dict):
            return set(left) == set(right) and all(
                same_type_value(left[key], right[key]) for key in right
            )
        if isinstance(right, list):
            return len(left) == len(right) and all(
                same_type_value(a, b) for a, b in zip(left, right)
            )
        return left == right

    if not same_type_value(actual, expected):
        raise SystemExit(f"color-field contract mismatch: {label}")


expected_anchors = {
    "orange": {"symbol": "🧡", "subject": "Dawa", "meanings": ["fire", "survival", "work", "persistence", "heart_of_gold", "warmth", "heat"]},
    "blue": {"symbol": "💙", "subject": "Avalhla", "meanings": ["base", "presence", "depth", "intelligence", "water"]},
    "green": {"symbol": "💚", "subject": "code", "meanings": ["building", "implementation", "technical_growth", "nature"]},
    "yellow": {"symbol": "💛", "subject": "comedy", "meanings": ["play", "brightness", "unexpected_joy", "sun"]},
    "red": {"symbol": "❤️", "subject": "attention", "meanings": ["boundary", "danger", "notice", "love"]},
    "purple": {"symbol": "💜", "subject": "dream", "meanings": ["strange", "dreaming", "deep_imagination", "fantasy"]},
}
expected_authority = {
    "color_is_identity": False,
    "color_is_evidence": False,
    "color_is_authority": False,
    "color_is_security": False,
    "rgb_distance_is_semantic_distance": False,
    "rgb_distance_is_perceptual_truth": False,
}
expected_family = {
    "multiple_allowed": True,
    "empty_allowed": True,
    "forced_single_family": False,
    "unanchored_is_valid": True,
    "family_is_expressive_relationship": True,
    "anchor_is_landmark": True,
}

if not isinstance(doc, dict):
    raise SystemExit("color-field contract mismatch: document must be an object")
require(doc.get("schema"), "avalhla.color-field.v1", "schema")
require(doc.get("status"), "CANONICAL_COMPUTABLE_SOURCE", "status")
require(doc.get("authority_boundary"), "expressive_reference_only", "authority_boundary")
require(doc.get("representation"), {"color_space": "sRGB", "format": "hex-rgb", "pattern": "#RRGGBB"}, "representation")
require(doc.get("anchors_are"), "landmarks_not_definitions", "anchors_are")
require(doc.get("anchors"), expected_anchors, "anchors")
require(doc.get("family_rules"), expected_family, "family_rules")
require(doc.get("authority_rules"), expected_authority, "authority_rules")
require(doc.get("avash", {}).get("source_ash_and_record_ash_distinct"), True, "AvAsh provenance distinction")
require(doc.get("relationship"), {
    "Dawa": "chooses",
    "AvvA": "carries_relation",
    "Avalhla": "may_notice",
    "DevilAsh": "checks_boundary",
}, "relationship")
print("COLOR_FIELD_OK")
PY
}

ava_color_field_get() {
    local path="$1"
    python3 - "$COLOR_FIELD_FILE" "$path" <<'PY'
import json
import sys

value = json.load(open(sys.argv[1], encoding="utf-8"))
for part in sys.argv[2].split("."):
    value = value[part]
if isinstance(value, (dict, list)):
    print(json.dumps(value, ensure_ascii=False, sort_keys=True))
else:
    print(value)
PY
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    case "${1:-validate}" in
        validate) ava_color_field_validate ;;
        file) ava_color_field_file ;;
        get)
            shift
            [[ $# -eq 1 ]] || { printf '%s\n' 'usage: lib_color_field.sh get dotted.path' >&2; exit 2; }
            ava_color_field_get "$1"
            ;;
        *) printf '%s\n' 'usage: lib_color_field.sh {validate|file|get dotted.path}' >&2; exit 2 ;;
    esac
fi
