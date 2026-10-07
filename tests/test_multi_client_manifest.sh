#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

python3 - <<'PY'
import json
from pathlib import Path


path = Path("config/avalhla-multi-client.v1.json")
if not path.is_file():
    raise SystemExit("multi-client manifest is missing")

with path.open(encoding="utf-8") as handle:
    manifest = json.load(handle)

if manifest.get("schema_version") != "avalhla-multi-client.v1":
    raise SystemExit("unexpected multi-client manifest schema")

identities = manifest.get("persona_identities", {})
if set(identities) != {"VALHLA", "LHLAVA"}:
    raise SystemExit("active source must contain exactly VALHLA and LHLAVA")
if any(entry.get("authority") != "evidence_only" for entry in identities.values()):
    raise SystemExit("persona identities must remain evidence-only")

for name in ("KING.VEX", "LHLAVA", "ANGEL.LUX", "VALHLA", "AVALHLA", "AV:VA"):
    if name not in manifest.get("speakers", {}):
        raise SystemExit(f"missing speaker profile: {name}")

clients = manifest.get("clients", {})
for name in ("claude_code", "codex_cli", "copilot", "dawa_desktop"):
    if name not in clients:
        raise SystemExit(f"missing client profile: {name}")

repositories = manifest.get("repositories", {})
if repositories.get("destiny_tower", {}).get("state") != "virtual":
    raise SystemExit("Destiny Tower must begin as a virtual repository profile")
if "repository_url" in repositories["destiny_tower"]:
    raise SystemExit("virtual Destiny Tower must not invent a repository URL")

mcp = manifest.get("mcp", {})
for name in ("avalhla", "desktop_commander"):
    entry = mcp.get(name, {})
    if entry.get("auto_start") is not True:
        raise SystemExit(f"shared MCP entry is not auto-start enabled: {name}")
    expected_auth = "one_time_client_auth" if name == "avalhla" else "local_process"
    if entry.get("auth_mode") != expected_auth:
        raise SystemExit(f"shared MCP entry has an unsafe auth mode: {name}")

for speaker in manifest.get("speakers", {}).values():
    serialized = json.dumps(speaker).lower()
    for forbidden in ("token", "credential", "provider", "permission_grant", "model"):
        if forbidden in speaker or forbidden in serialized:
            raise SystemExit(f"speaker profile contains forbidden authority field: {forbidden}")

if manifest.get("authority", {}).get("final_decision") != "DAWA":
    raise SystemExit("Dawa must remain the final decision authority")

print("MULTI_CLIENT_MANIFEST_TEST_OK")
PY
