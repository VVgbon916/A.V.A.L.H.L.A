#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

SETUP="$ROOT/scripts/avalhla-client-setup"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

CONFIG="$TMP/client.json"
DESKTOP="$TMP/desktop-commander"
NODE="$TMP/node"
ENTRYPOINT="$TMP/desktop-entrypoint.js"
BACKUPS="$TMP/backups"
printf '#!/bin/sh\n' > "$DESKTOP"
chmod +x "$DESKTOP"
printf '#!/bin/sh\n' > "$NODE"
chmod +x "$NODE"
printf '// fixture entrypoint\n' > "$ENTRYPOINT"

cat > "$CONFIG" <<'JSON'
{
  "mcpServers": {
    "existing": {"command": "keep-me"},
    "desktop-commander": {"command": "old", "args": ["old"], "type": "local", "tools": ["*"]}
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
for name in ("avalhla", "desktop-commander"):
    if name not in servers:
        raise SystemExit(f"missing applied MCP entry: {name}")
if config["auth"]["access_token"] != "SECRET_MUST_SURVIVE":
    raise SystemExit("auth block was changed")
if servers["desktop-commander"].get("type") != "local" or servers["desktop-commander"].get("tools") != ["*"]:
    raise SystemExit("unowned Desktop Commander fields were removed")
if len(list(backup_dir.glob("client.json.*.bak"))) != 1:
    raise SystemExit("apply did not create exactly one backup")
PY

AFTER="$(sha256sum "$CONFIG" | awk '{print $1}')"
$SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG" --desktop-command "$DESKTOP" --backup-dir "$BACKUPS" >/dev/null
if [[ "$(sha256sum "$CONFIG" | awk '{print $1}')" != "$AFTER" ]]; then
  echo "repeated apply was not idempotent" >&2
  exit 1
fi

CONFIG2="$TMP/two-part-client.json"
printf '{"mcpServers": {}}\n' > "$CONFIG2"
$SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG2" --desktop-node "$NODE" --desktop-entrypoint "$ENTRYPOINT" --backup-dir "$BACKUPS" >/dev/null
python3 - "$CONFIG2" "$NODE" "$ENTRYPOINT" <<'PY'
import json
import sys

config = json.load(open(sys.argv[1], encoding="utf-8"))
server = config["mcpServers"]["desktop-commander"]
if server.get("command") != sys.argv[2] or server.get("args") != [sys.argv[3]]:
    raise SystemExit("two-part Desktop Commander command was not preserved")
PY

NODE_ALIAS="$TMP/node-alias"
ENTRYPOINT_ALIAS="$TMP/entrypoint-alias.js"
ln -s "$NODE" "$NODE_ALIAS"
ln -s "$ENTRYPOINT" "$ENTRYPOINT_ALIAS"
CONFIG3="$TMP/alias-client.json"
python3 - "$CONFIG3" "$NODE" "$ENTRYPOINT" <<'PY'
import json
import sys

json.dump({"mcpServers": {"desktop-commander": {"command": sys.argv[2], "args": [sys.argv[3]]}}}, open(sys.argv[1], "w", encoding="utf-8"))
PY
ALIAS_PLAN="$($SETUP plan --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$CONFIG3" --desktop-node "$NODE_ALIAS" --desktop-entrypoint "$ENTRYPOINT_ALIAS")"
[[ "$ALIAS_PLAN" == *"action=unchanged server=desktop-commander"* ]] || { echo "equivalent Desktop Commander paths caused churn" >&2; exit 1; }

printf '{not-json\n' > "$TMP/bad.json"
if $SETUP apply --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --config "$TMP/bad.json" --desktop-command "$DESKTOP" --backup-dir "$BACKUPS" >/dev/null 2>&1; then
  echo "malformed config was accepted" >&2
  exit 1
fi

echo "CLIENT_SETUP_TEST_OK"
