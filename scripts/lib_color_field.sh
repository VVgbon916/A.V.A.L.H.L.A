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

assert doc["schema"] == "avalhla.color-field.v1"
assert doc["status"] == "CANONICAL_COMPUTABLE_SOURCE"
assert set(doc["anchors"]) == {"orange", "blue", "green", "yellow", "red", "purple"}
assert doc["family_rules"]["multiple_allowed"] is True
assert doc["family_rules"]["empty_allowed"] is True
assert doc["family_rules"]["forced_single_family"] is False
assert doc["family_rules"]["unanchored_is_valid"] is True
assert all(value is False for value in doc["authority_rules"].values())
assert doc["avash"]["source_ash_and_record_ash_distinct"] is True
assert doc["relationship"]["dawa"] == "chooses"
assert doc["relationship"]["avvA"] == "carries_relation"
assert doc["relationship"]["avalhla"] == "may_notice"
assert doc["relationship"]["devilash"] == "checks_boundary"
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
