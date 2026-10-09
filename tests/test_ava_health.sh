#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

curl() {
    case "$*" in
        *"/api/tags"*)
            printf '{"models":[{"name":"avalhla"},{"name":"avalhla-chat"},{"name":"avalhla-code"},{"name":"avalhla-review"}]}\n'
            ;;
        *"/api/generate"*)
            printf '%s\n' '{"response":"VERDICT: healthy\n[READ: hidden]"}'
            ;;
        *)
            printf 'unexpected curl request: %s\n' "$*" >&2
            return 1
            ;;
    esac
}
export -f curl

OUTPUT="$("$ROOT/scripts/ava-health")"
[[ "$OUTPUT" == *"AUDIT:"* ]]
[[ "$OUTPUT" == *"DOORS:"* ]]
[[ "$OUTPUT" == *"MODEL: reachable, all required models present"* ]]
[[ "$OUTPUT" == *"GATE: skipped"* ]]

EXPLAIN="$(AVA_HEALTH_MODEL=test "$ROOT/scripts/ava-health" --explain)"
[[ "$EXPLAIN" == *"VERDICT: healthy"* ]]
[[ "$EXPLAIN" != *"[READ:"* ]]

"$ROOT/scripts/ava-health" --self-test >/dev/null

printf '%s\n' 'AVA_HEALTH_OUTPUT_GATE_TEST_OK'
