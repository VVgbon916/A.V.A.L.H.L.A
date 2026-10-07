#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

FORMATTER="$ROOT/scripts/avalhla-dialogue"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/paired.json" <<'JSON'
{
  "turns": [
    {"speaker": "KING.VEX", "text": "Find the hidden failure first."},
    {"speaker": "LHLAVA", "text": "I found the smallest reproducible path."}
  ]
}
JSON

cat > "$TMP/one-speaker.json" <<'JSON'
{
  "turns": [
    {"speaker": "ANGEL.LUX", "text": "The source needs provenance."}
  ]
}
JSON

if [[ ! -x "$FORMATTER" ]]; then
  echo "dialogue formatter is missing" >&2
  exit 1
fi

CLAUDE="$($FORMATTER render --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client claude_code --view structural --input "$TMP/paired.json")"
[[ "$CLAUDE" == *"[KING.VEX | flame-red | adversarial-demon]"* ]] || { echo "missing King.Vex style" >&2; exit 1; }
[[ "$CLAUDE" == *"[LHLAVA | fire-orange | rapid-builder]"* ]] || { echo "missing Lhlava style" >&2; exit 1; }
[[ "$CLAUDE" == *"## Evidence"* && "$CLAUDE" == *"## Challenge"* ]] || { echo "missing structural sections" >&2; exit 1; }
KING_POS="$(printf '%s' "$CLAUDE" | grep -b -o '\[KING\.VEX' | head -n1 | cut -d: -f1)"
LHLAVA_POS="$(printf '%s' "$CLAUDE" | grep -b -o '\[LHLAVA' | head -n1 | cut -d: -f1)"
(( KING_POS < LHLAVA_POS )) || { echo "paired speakers are out of order" >&2; exit 1; }

CODEX="$($FORMATTER render --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client codex_cli --view compact --input "$TMP/one-speaker.json")"
[[ "$CODEX" == *"[ANGEL.LUX | healing-gold | careful-angel-review]"* ]] || { echo "missing Angel.Lux style" >&2; exit 1; }
[[ "$CODEX" == *"[VALHLA | aura-blue | spirit-research]"* ]] || { echo "missing canonical Valhla fallback" >&2; exit 1; }
[[ "$CODEX" != *"VHALA"* ]] || { echo "misspelled VHALA speaker emitted" >&2; exit 1; }
[[ "$CODEX" == *"awaiting paired response"* ]] || { echo "missing one-speaker fallback" >&2; exit 1; }

DAWA="$($FORMATTER render --manifest "$ROOT/config/avalhla-multi-client.v1.json" --client dawa_desktop --view diff --input "$TMP/paired.json")"
[[ "$DAWA" == *"[AVALHLA | violet-synthesis | independent-synthesis]"* ]] || { echo "missing Avalhla synthesis style" >&2; exit 1; }
[[ "$DAWA" == *"[AV:VA | prismatic-cumulative | multi-source-echo]"* ]] || { echo "missing Av:vA style" >&2; exit 1; }
[[ "$DAWA" == *"Dawa decision"* ]] || { echo "missing Dawa decision boundary" >&2; exit 1; }

echo "DIALOGUE_TEST_OK"
