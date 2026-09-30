#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck source=scripts/lib_color_field.sh
source "$ROOT/scripts/lib_color_field.sh"

ava_color_field_validate >/dev/null

python3 - "$COLOR_FIELD_FILE" <<'PY'
import json
import sys

doc = json.load(open(sys.argv[1], encoding="utf-8"))
checks = (
    len(doc["anchors"]) == 6,
    doc["family_rules"]["multiple_allowed"] is True,
    doc["family_rules"]["empty_allowed"] is True,
    doc["family_rules"]["forced_single_family"] is False,
    doc["family_rules"]["unanchored_is_valid"] is True,
    set(doc["authority_rules"]) == {
        "color_is_identity", "color_is_evidence", "color_is_authority",
        "color_is_security", "rgb_distance_is_semantic_distance",
        "rgb_distance_is_perceptual_truth",
    },
    all(value is False for value in doc["authority_rules"].values()),
)
if not all(checks):
    raise SystemExit("Color Field contract test failed")
print("COLOR_FIELD_TEST_OK")
PY

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT INT TERM HUP

expect_invalid() {
    local name="$1" mutation="$2"
    local candidate="$tmp/$name.json"
    cp -- "$COLOR_FIELD_FILE" "$candidate"
    python3 - "$candidate" "$mutation" <<'PY'
import json
import sys

path, mutation = sys.argv[1:]
with open(path, encoding="utf-8") as stream:
    doc = json.load(stream)
if mutation == "anchor":
    doc["anchors"]["orange"]["subject"] = "attacker"
elif mutation == "authority":
    doc["authority_rules"] = {}
elif mutation == "schema":
    doc["schema"] = "avalhla.color-field.attacker"
with open(path, "w", encoding="utf-8") as stream:
    json.dump(doc, stream)
PY
    if AVA_COLOR_FIELD_FILE="$candidate" PYTHONOPTIMIZE=1 bash "$ROOT/scripts/lib_color_field.sh" validate >/dev/null 2>&1; then
        printf 'FAIL: optimized validator accepted altered %s\n' "$name" >&2
        exit 1
    fi
    printf 'PASS: optimized validator rejects altered %s\n' "$name"
}

expect_invalid changed-anchor anchor
expect_invalid missing-authority authority
expect_invalid altered-schema schema
