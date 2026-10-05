#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
P="$ROOT/scripts/ava-cobuilder-projection"
python3 -c 'import json;print(json.dumps({"schema":"x","safety":"s","extensions":"E"*100000}))' > "$T/m.json"
out="$("$P" "$T/m.json")"
[[ ${#out} -lt 65536 ]] || { echo "FAIL: too big"; exit 1; }
grep -q '"safety"' <<<"$out" || { echo "FAIL: kept key missing"; exit 1; }
! grep -q 'EEEE' <<<"$out" || { echo "FAIL: dropped key leaked"; exit 1; }
echo '{bad' > "$T/b.json"
! "$P" "$T/b.json" 2>/dev/null || { echo "FAIL: invalid json accepted"; exit 1; }
ln -s "$T/m.json" "$T/l.json"
! "$P" "$T/l.json" 2>/dev/null || { echo "FAIL: symlink accepted"; exit 1; }
! "$P" "$T/none.json" 2>/dev/null || { echo "FAIL: missing accepted"; exit 1; }
! AVA_PROJECTION_MAX_BYTES=10 "$P" "$T/m.json" 2>/dev/null || { echo "FAIL: cap ignored"; exit 1; }
real="$("$P")" || { echo "FAIL: real master"; exit 1; }
grep -q '"consultation_lanes"' <<<"$real" || { echo "FAIL: role summary omitted"; exit 1; }
grep -q '"skill_activation"' <<<"$real" || { echo "FAIL: on-demand rule omitted"; exit 1; }
if grep -Fq '/var/home/VVgbon/Dawa_Notepad/' <<<"$real"; then
    echo "FAIL: private absolute path entered projection"
    exit 1
fi
echo AVA_COBUILDER_PROJECTION_TEST_OK
