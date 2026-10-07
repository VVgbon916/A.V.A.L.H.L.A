#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

AUDIT="$ROOT/scripts/avalhla-plugin-audit"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/inventory.json" <<'JSON'
{
  "plugins": [
    {"name": "Supabase", "state": "enabled"},
    {"name": "canvas-authoring", "state": "disabled", "requires": ["dnx"]},
    {"name": "OpenAI Developers", "state": "auth-needed"}
  ]
}
JSON

if [[ ! -x "$AUDIT" ]]; then
  echo "plugin audit tool is missing" >&2
  exit 1
fi

CATALOG="$($AUDIT catalog --catalog "$ROOT/config/plugin-role-catalog.v1.json")"
[[ "$CATALOG" == *"role=code_and_repository"* ]] || { echo "missing code plugin role" >&2; exit 1; }
[[ "$CATALOG" == *"activation_policy=catalogue_and_on_demand"* ]] || { echo "missing activation policy" >&2; exit 1; }

BEFORE="$(sha256sum "$TMP/inventory.json" | awk '{print $1}')"
REPORT="$($AUDIT check --catalog "$ROOT/config/plugin-role-catalog.v1.json" --inventory "$TMP/inventory.json" --available-commands "bash")"
AFTER="$(sha256sum "$TMP/inventory.json" | awk '{print $1}')"
[[ "$BEFORE" == "$AFTER" ]] || { echo "plugin audit modified inventory" >&2; exit 1; }
[[ "$REPORT" == *"Supabase: installed-enabled"* ]] || { echo "enabled classification missing" >&2; exit 1; }
[[ "$REPORT" == *"canvas-authoring: deferred"* ]] || { echo "missing prerequisite was not deferred" >&2; exit 1; }
[[ "$REPORT" == *"OpenAI Developers: installed-auth-needed"* ]] || { echo "auth-needed classification missing" >&2; exit 1; }
[[ "$REPORT" == *"Exa: not-installed"* ]] || { echo "missing plugin classification missing" >&2; exit 1; }

echo "PLUGIN_AUDIT_TEST_OK"
