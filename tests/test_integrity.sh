#!/usr/bin/env bash
set -Eeuo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "$HERE/.." && pwd -P)"
# shellcheck source=scripts/lib_integrity.sh
source "$ROOT/scripts/lib_integrity.sh"

PASS=0
FAIL=0

ok() {
    printf '  [ OK ] %s\n' "$1"
    PASS=$((PASS + 1))
}

bad() {
    printf '  [FAIL] %s -- %s\n' "$1" "$2"
    FAIL=$((FAIL + 1))
}

TMP="$(mktemp -d)"
trap 'rm -rf -- "$TMP"' EXIT INT TERM HUP

printf 'hello world\n' > "$TMP/sample.txt"

EXPECTED="$(ava_integrity_sha256_file "$TMP/sample.txt")"

if ava_integrity_sha256_valid "$EXPECTED"; then
    ok 'SHA-256 shape'
else
    bad 'SHA-256 shape' 'digest was not 64 hex characters'
fi

if ava_integrity_verify_file "$TMP/sample.txt" "$EXPECTED"; then
    ok 'file verification passes'
else
    bad 'file verification passes' 'matching digest was rejected'
fi

BYTES=$'hello world\n'
EXPECTED_BYTES="$(ava_integrity_sha256_bytes "$BYTES")"

if [[ "$EXPECTED_BYTES" == "$EXPECTED" ]]; then
    ok 'byte/file digest agreement'
else
    bad 'byte/file digest agreement' 'same bytes produced different digests'
fi

if ava_integrity_verify_bytes "$BYTES" "$EXPECTED_BYTES"; then
    ok 'byte verification passes'
else
    bad 'byte verification passes' 'matching byte digest was rejected'
fi

printf 'changed\n' > "$TMP/sample.txt"

if ava_integrity_verify_file "$TMP/sample.txt" "$EXPECTED"; then
    bad 'changed file is rejected' 'stale digest still passed'
else
    ok 'changed file is rejected'
fi

if ava_integrity_verify_file "$TMP/sample.txt" 'not-a-sha256'; then
    bad 'malformed expected digest is rejected' 'invalid digest was accepted'
else
    ok 'malformed expected digest is rejected'
fi

if ava_integrity_sha256_file "$TMP/missing.txt" >/dev/null 2>&1; then
    bad 'missing file is rejected' 'missing path unexpectedly hashed'
else
    ok 'missing file is rejected'
fi

printf '\n== integrity summary ==\n'
printf '  pass: %d\n  fail: %d\n' "$PASS" "$FAIL"

if (( FAIL == 0 )); then
    printf '%s\n' '  result: ALL GREEN'
else
    printf '%s\n' '  result: FAIL'
    exit 1
fi
