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
assert len(doc["anchors"]) == 6
assert doc["family_rules"]["multiple_allowed"] is True
assert doc["family_rules"]["empty_allowed"] is True
assert doc["family_rules"]["forced_single_family"] is False
assert doc["family_rules"]["unanchored_is_valid"] is True
assert all(value is False for value in doc["authority_rules"].values())
print("COLOR_FIELD_TEST_OK")
PY
