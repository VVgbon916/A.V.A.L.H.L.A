#!/usr/bin/env bash
# test_safety_self_test.sh -- Phase 02 public contract: `ava-safety --self-test`
# must PASS and must leave no isolation directories behind.
# Runs against the canonical runtime root only; it never redirects AVA_ROOT.
set -Euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
ROOT="/var/home/VVgbon/Avalhla"
MEM="$ROOT/memory"
failures=0

if [[ ! -d "$MEM" ]]; then
    echo "SAFETY_SELF_TEST_STATUS=SKIP canonical root $MEM absent"
    exit 0
fi

leaks() {
    find "$ROOT" "$MEM" -maxdepth 1 -name '.ava-safety-self-test.*' 2>/dev/null | sort
}

before="$(leaks)"
out="$(bash "$REPO/scripts/ava-safety" --self-test 2>/dev/null)"; rc=$?
after="$(leaks)"

if (( rc == 0 )) && grep -qx 'SELF_TEST_STATUS=PASS' <<<"$out"; then
    echo '  [ OK ] ava-safety --self-test dispatches and passes'
else
    echo "  [FAIL] ava-safety --self-test rc=$rc"; failures=$((failures + 1))
fi

if [[ "$before" == "$after" ]]; then
    echo '  [ OK ] self-test leaves no isolation directories behind'
else
    echo '  [FAIL] self-test leaked:'; comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after") | sed 's/^/         /'
    failures=$((failures + 1))
fi

# Caller EXIT trap must survive the self-test (library must not steal it).
probe="$(bash -c '
    trap "echo CALLER_TRAP_RAN" EXIT
    source "$1/scripts/lib_runtime.sh"; source "$1/scripts/lib_safety.sh"
    ava_safety_self_test >/dev/null 2>&1
' _ "$REPO")"
if [[ "$probe" == *CALLER_TRAP_RAN* ]]; then
    echo '  [ OK ] caller EXIT trap preserved'
else
    echo '  [FAIL] caller EXIT trap was replaced'; failures=$((failures + 1))
fi

(( failures == 0 )) && { echo 'SAFETY_SELF_TEST_STATUS=PASS'; exit 0; }
printf 'SAFETY_SELF_TEST_STATUS=FAIL failures=%d\n' "$failures"; exit 1
