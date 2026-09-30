#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "$ROOT/scripts/lib_review_gate.sh"

check_pass() {
    local label="$1" input="$2"
    if ! printf '%s\n' "$input" | ava_review_validate >/dev/null; then
        printf 'FAIL: %s should pass\n' "$label" >&2
        exit 1
    fi
    printf 'PASS: %s\n' "$label"
}

check_fail() {
    local label="$1" input="$2"
    if printf '%s\n' "$input" | ava_review_validate >/dev/null 2>&1; then
        printf 'FAIL: %s should fail\n' "$label" >&2
        exit 1
    fi
    printf 'PASS: %s\n' "$label"
}

check_pass "block report" 'BUGS
none
SECURITY
- scripts/example.sh:12 -- unsafe path handling -- validate the resolved path
PERF
none
STYLE
none
VERDICT
fix-first'

check_pass "inline clean report" 'BUGS: none
SECURITY: none
PERF: none
STYLE: none
VERDICT: fix-first'

check_pass "inline finding" 'BUGS: - scripts/example.sh:12 -- unsafe path handling -- validate the resolved path
SECURITY: none
PERF: none
STYLE: none
VERDICT: fix-first'

check_pass "markdown headings" '# BUGS
none
# SECURITY
none
# PERF
none
# STYLE
none
# VERDICT
fix-first'

check_fail "missing section" 'BUGS
none
SECURITY
none
PERF
none
STYLE
none'

check_fail "out-of-order sections" 'SECURITY
none
BUGS
none
PERF
none
STYLE
none
VERDICT
fix-first'

check_fail "malformed finding" 'BUGS
- malformed finding
SECURITY
none
PERF
none
STYLE
none
VERDICT
fix-first'

check_fail "mixed none and findings" 'BUGS
none
- scripts/example.sh:12 -- problem -- fix
SECURITY
none
PERF
none
STYLE
none
VERDICT
fix-first'

check_fail "duplicate section" 'BUGS
none
BUGS
none
SECURITY
none
PERF
none
STYLE
none
VERDICT
fix-first'

check_fail "invalid inline verdict" 'BUGS: none
SECURITY: none
PERF: none
STYLE: none
VERDICT: not-a-verdict'

check_fail "invalid block verdict" 'BUGS
none
SECURITY
none
PERF
none
STYLE
none
VERDICT
not-a-verdict'

check_fail "verdict with extra prose" 'BUGS: none
SECURITY: none
PERF: none
STYLE: none
VERDICT: fix-first -- review conclusion'

check_fail "content after verdict" 'BUGS
none
SECURITY
none
PERF
none
STYLE
none
VERDICT
fix-first
extra'

printf '\nReview-gate tests passed.\n'
