#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

CONTRACT="$(<scripts/ava-ci-contract)"
for required in \
  "config/avalhla-multi-client.v1.json" \
  "config/plugin-role-catalog.v1.json" \
  "tests/test_multi_client_manifest.sh" \
  "tests/test_client_setup.sh" \
  "tests/test_dialogue.sh" \
  "tests/test_plugin_audit.sh"; do
  if [[ "$CONTRACT" != *"$required"* ]]; then
    echo "CI contract is missing $required" >&2
    exit 1
  fi
done

scripts/avalhla-client-setup --help >/dev/null
scripts/avalhla-dialogue --help >/dev/null
scripts/avalhla-plugin-audit --help >/dev/null

python3 - <<'PY'
import json
from pathlib import Path

manifest = json.loads(Path("config/avalhla-multi-client.v1.json").read_text(encoding="utf-8"))
for speaker in manifest["speakers"].values():
    for forbidden in ("token", "credential", "provider", "model", "permission_grant"):
        if forbidden in json.dumps(speaker).lower():
            raise SystemExit(f"forbidden field in speaker contract: {forbidden}")
if "VHALA" in json.dumps(manifest):
    raise SystemExit("misspelled VHALA remains in the active manifest")
PY

echo "MULTI_CLIENT_CONTRACT_TEST_OK"
