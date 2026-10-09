#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SOURCE="$ROOT/memory/auto-read/00_AI_COBUILD.json"
PROJECTOR="$ROOT/scripts/ava-cobuilder-projection"
CHAT="$ROOT/scripts/ai-chat"

projection="$("$PROJECTOR" "$SOURCE")"
python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["_projection"].startswith("MODEL-INPUT ONLY")' <<<"$projection"

grep -Fq 'ava-cobuilder-projection' "$CHAT"
grep -Fq 'ava_autoread_load "$AUTO_READ_DIR" "$((65536 - used))" read_autoread_context' "$CHAT"
! grep -Fq 'for f in "$AUTO_READ_DIR"/*' "$CHAT"

printf 'AUTOREAD_PROJECTION=PASS\n'
