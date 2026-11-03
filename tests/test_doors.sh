#!/usr/bin/env bash
# test_doors.sh -- every door (scripts/*) is executable, bash, and parses.
set -Euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
failures=0

for door in "$REPO"/scripts/*; do
    name="$(basename "$door")"
    [[ -f "$door" ]] || continue
    case "$name" in
        lib_*.sh) ;;  # sourced libraries: syntax only
        *) [[ -x "$door" ]] || { printf '  [FAIL] %s not executable\n' "$name"; failures=$((failures + 1)); continue; } ;;
    esac
    if ! head -n1 -- "$door" | grep -Eq '^#!.*\b(bash|sh)\b'; then
        printf '  [FAIL] %s has no bash/sh shebang\n' "$name"; failures=$((failures + 1)); continue
    fi
    if bash -n -- "$door" 2>/dev/null; then
        printf '  [ OK ] %s\n' "$name"
    else
        printf '  [FAIL] %s syntax\n' "$name"; failures=$((failures + 1))
    fi
done

(( failures == 0 )) && { echo 'DOORS_STATUS=PASS'; exit 0; }
printf 'DOORS_STATUS=FAIL failures=%d\n' "$failures"; exit 1
