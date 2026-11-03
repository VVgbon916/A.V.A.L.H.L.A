#!/usr/bin/env bash
# tests/run.sh -- run every test in a guarded child bash; report one status.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failed=0
for t in "$HERE"/test_*.sh; do
    printf -- '-- %s --\n' "$(basename "$t")"
    bash "$t" || failed=$((failed + 1))
done
(( failed == 0 )) && { echo 'TESTS_STATUS=PASS'; exit 0; }
printf 'TESTS_STATUS=FAIL suites=%d\n' "$failed"; exit 1
