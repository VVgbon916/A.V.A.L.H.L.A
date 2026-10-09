#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

curl() {
    case "$*" in
        *"/api/tags"*)
            printf '{}\n'
            ;;
        *"/api/generate"*)
            printf '%s\n' '{"response":"WHAT: answer\n[READ: hidden]"}'
            ;;
        *)
            printf 'unexpected curl request: %s\n' "$*" >&2
            return 1
            ;;
    esac
}
export -f curl

OUTPUT="$(AVA_EXPLAIN_MODEL=test "$ROOT/scripts/ava-explain" 'printf test')"
[[ "$OUTPUT" == *"WHAT: answer"* ]]
[[ "$OUTPUT" != *"[READ:"* ]]

printf '%s\n' 'AVA_EXPLAIN_OUTPUT_GATE_TEST_OK'