#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INV="$ROOT/docs/architecture/AVA_MODE_INVENTORY.md"

[[ -f "$INV" ]] || { printf 'FAIL missing inventory: %s\n' "$INV" >&2; exit 1; }

for class in \
  'EXECUTABLE' \
  'CANONICAL_HUMAN' \
  'MACHINE_CONTRACT' \
  'COMPATIBILITY' \
  'LORE' \
  'HISTORICAL'
do
  grep -Fq "$class" "$INV" || { printf 'FAIL missing classification: %s\n' "$class" >&2; exit 1; }
done

for surface in \
  'scripts/' \
  'memory/auto-read/00_AI_COBUILD.json' \
  'persona/' \
  'config/' \
  'systemd/' \
  'tests/' \
  '.github/workflows/' \
  'AwA_ATLAS.md' \
  'AwA_DREAM.md' \
  'AwA_TERMINAL.md' \
  'AwA_WEAVE.md'
do
  grep -Fq "$surface" "$INV" || { printf 'FAIL missing surface: %s\n' "$surface" >&2; exit 1; }
done

grep -Fq 'NO_BLIND_RENAME' "$INV" || { printf 'FAIL missing no-blind-rename invariant\n' >&2; exit 1; }
grep -Fq 'Dawa chooses.' "$INV" || { printf 'FAIL missing authority invariant\n' >&2; exit 1; }

printf 'AVA_MODE_INVENTORY=PASS\n'
