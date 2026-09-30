#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT INT TERM HUP

mkdir -p "$tmp/imagination/HUMAN" "$tmp/imagination"
printf '> color: orange\n' > "$tmp/imagination/HUMAN/safe-entry.md"
printf '> color: red\n' > "$tmp/imagination/escaped-entry.md"

if AVA_IMAGINE_ROOT="$tmp/imagination" AVA_MOOD_DIR="$tmp/state" "$ROOT/scripts/ava-mood" ref ../escaped-entry >/dev/null 2>&1; then
    printf '%s\n' 'FAIL: traversal slug was accepted' >&2
    exit 1
fi
[[ ! -e "$tmp/state/mood.json" ]] || {
    printf '%s\n' 'FAIL: rejected reference changed mood state' >&2
    exit 1
}

AVA_IMAGINE_ROOT="$tmp/imagination" AVA_MOOD_DIR="$tmp/state" "$ROOT/scripts/ava-mood" ref safe-entry >/dev/null
[[ "$(jq -r .color "$tmp/state/mood.json")" == orange ]] || {
    printf '%s\n' 'FAIL: valid mood reference was not adopted' >&2
    exit 1
}

printf '{"mode":"ref","ref":"../escaped-entry"}\n' > "$tmp/state/mood.json"
output="$(AVA_IMAGINE_ROOT="$tmp/imagination" AVA_MOOD_DIR="$tmp/state" "$ROOT/scripts/ava-mood" show)"
[[ "$output" == *'mode  : auto'* && "$output" != *'color : red'* ]] || {
    printf '%s\n' 'FAIL: persisted traversal reference was followed' >&2
    exit 1
}

printf '%s\n' 'AVA_MOOD_TEST_OK'
