#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck source=scripts/lib_integrity.sh
source "$ROOT/scripts/lib_integrity.sh"

pass=0
fail=0
ok() { printf '  [ OK ] %s\n' "$1"; pass=$((pass + 1)); }
bad() { printf '  [FAIL] %s -- %s\n' "$1" "$2" >&2; fail=$((fail + 1)); }

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT INT TERM HUP

printf 'hello world\n' > "$tmp/sample.txt"
expected="$(ava_integrity_sha256_file "$tmp/sample.txt")"

ava_integrity_sha256_valid "$expected" && ok 'SHA-256 shape' || bad 'SHA-256 shape' 'digest rejected'
ava_integrity_verify_file "$tmp/sample.txt" "$expected" && ok 'file verification passes' || bad 'file verification passes' 'matching digest rejected'

bytes=$'hello world\n'
byte_hash="$(ava_integrity_sha256_bytes "$bytes")"
[[ "$byte_hash" == "$expected" ]] && ok 'byte/file digest agreement' || bad 'byte/file digest agreement' 'same bytes produced different digests'
ava_integrity_verify_bytes "$bytes" "$expected" && ok 'byte verification passes' || bad 'byte verification passes' 'matching byte digest rejected'

printf 'changed\n' > "$tmp/sample.txt"
if ava_integrity_verify_file "$tmp/sample.txt" "$expected"; then
    bad 'changed file is rejected' 'stale digest still passed'
else
    ok 'changed file is rejected'
fi

if ava_integrity_verify_file "$tmp/sample.txt" 'not-a-sha256'; then
    bad 'malformed expected digest is rejected' 'invalid digest accepted'
else
    ok 'malformed expected digest is rejected'
fi

if ava_integrity_sha256_file "$tmp/missing.txt" >/dev/null 2>&1; then
    bad 'missing file is rejected' 'missing path was hashed'
else
    ok 'missing file is rejected'
fi

printf '\n== integrity summary ==\n  pass: %d\n  fail: %d\n' "$pass" "$fail"
if (( fail == 0 )); then
    printf '%s\n' '  result: ALL GREEN'
else
    printf '%s\n' '  result: FAIL'
    exit 1
fi
