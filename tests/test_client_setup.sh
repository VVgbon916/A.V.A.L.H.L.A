#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

SETUP="$ROOT/scripts/avalhla-client-setup"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

CONFIG="$TMP/client.json"
DESKTOP="$TMP/desktop-commander"
BACKUPS="$TMP/backups"
printf '#!/bin/sh\n' > "$DESKTOP"
chmod +x "$DESKTOP"

cat > "$CONFIG" <<'JSON'
{
  "mcpServers": {
    "existing": {"command": "keep-me"}
  },
  "auth": {"access_token": "SECRET_MUST_SURVIVE"}
}
JSON

if [[ ! -x "$SETUP" ]]; then
  echo "client setup tool is missing" >&2
  exit 1
fi

BEFORE="$(sha256sum "$CONFIG" | awk '{print $1}')"
PLAN="$($SETUP plan --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG" --desktop-command "$DESKTOP")"
if [[ "$(sha256sum "$CONFIG" | awk '{print $1}')" != "$BEFORE" ]]; then
  echo "plan mode modified the target config" >&2
  exit 1
fi
if [[ "$PLAN" != *"action=add"* && "$PLAN" != *"action=update"* ]]; then
  echo "plan output did not describe MCP changes" >&2
  exit 1
fi
if [[ "$PLAN" == *"SECRET_MUST_SURVIVE"* ]]; then
  echo "plan output leaked a secret" >&2
  exit 1
fi

$SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG" --desktop-command "$DESKTOP" --backup-dir "$BACKUPS" >/dev/null
python3 - "$CONFIG" "$BACKUPS" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
backup_dir = Path(sys.argv[2])
config = json.loads(config_path.read_text(encoding="utf-8"))
servers = config["mcpServers"]
if "existing" not in servers or servers["existing"]["command"] != "keep-me":
    raise SystemExit("unrelated MCP entry was not preserved")
for name in ("avalhla", "desktop_commander"):
    if name not in servers:
        raise SystemExit(f"missing applied MCP entry: {name}")
if config["auth"]["access_token"] != "SECRET_MUST_SURVIVE":
    raise SystemExit("auth block was changed")
if len(list(backup_dir.glob("client.json.*.bak"))) != 1:
    raise SystemExit("apply did not create exactly one backup")
PY

AFTER="$(sha256sum "$CONFIG" | awk '{print $1}')"
$SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG" --desktop-command "$DESKTOP" --backup-dir "$BACKUPS" >/dev/null
if [[ "$(sha256sum "$CONFIG" | awk '{print $1}')" != "$AFTER" ]]; then
  echo "repeated apply was not idempotent" >&2
  exit 1
fi

printf '{not-json\n' > "$TMP/bad.json"
if $SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$TMP/bad.json" --desktop-command "$DESKTOP" --backup-dir "$BACKUPS" >/dev/null 2>&1; then
  echo "malformed config was accepted" >&2
  exit 1
fi

echo "CLIENT_SETUP_TEST_OK"
