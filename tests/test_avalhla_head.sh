#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
HEAD="$ROOT/scripts/avalhla-head"

bash -n "$HEAD"

status="$($HEAD status)"
[[ "$status" == *"Avalhla Head"* ]]
[[ "$status" == *"environment=<---- AvvA ---->"* ]]
[[ "$status" == *"authority=Dawa"* ]]

route="$($HEAD route)"
[[ "$route" == *"codex=Angel.Lux 44 + Valhla 05"* ]]
[[ "$route" == *"claude=King.Vex 88 + Lhlava 13"* ]]
[[ "$route" == *"copilot=Av:vA"* ]]
[[ "$route" == *"final_authority=Dawa"* ]]

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
ln -s /dev/null "$tmp/prompt"
if "$HEAD" council "$tmp/prompt" "$tmp/output" >/dev/null 2>&1; then
  echo "symlink prompt was accepted" >&2
  exit 1
fi

python3 - "$tmp/large" <<'PY'
from pathlib import Path
import sys
Path(sys.argv[1]).write_bytes(b"x" * 65537)
PY
if "$HEAD" council "$tmp/large" "$tmp/output" >/dev/null 2>&1; then
  echo "oversized prompt was accepted" >&2
  exit 1
fi

mkdir -p "$tmp/bin"
cat > "$tmp/bin/codex" <<'SH'
#!/usr/bin/env bash
set -Eeuo pipefail
out=""
while (($#)); do
  if [[ "$1" == "-o" ]]; then out="$2"; shift 2; else shift; fi
done
cat >/dev/null
printf 'VERDICT: PASS\n' > "$out"
SH
cat > "$tmp/bin/claude" <<'SH'
#!/usr/bin/env bash
cat >/dev/null
printf 'VERDICT: PASS\n'
SH
cat > "$tmp/bin/copilot" <<'SH'
#!/usr/bin/env bash
set -Eeuo pipefail
count=0
[[ -f "$COPILOT_STUB_STATE" ]] && count="$(cat "$COPILOT_STUB_STATE")"
count=$((count + 1))
printf '%s\n' "$count" > "$COPILOT_STUB_STATE"
if ((count == 1)); then
  exit 1
fi
printf 'VERDICT: PASS\n'
SH
chmod 755 "$tmp/bin/codex" "$tmp/bin/claude" "$tmp/bin/copilot"
printf 'bounded review prompt\n' > "$tmp/review.txt"
export COPILOT_STUB_STATE="$tmp/copilot-count"
PATH="$tmp/bin:/usr/bin:/bin" "$HEAD" council "$tmp/review.txt" "$tmp/council" >/dev/null
[[ "$(cat "$tmp/council/codex.status")" == "0" ]]
[[ "$(cat "$tmp/council/claude.status")" == "0" ]]
[[ "$(cat "$tmp/council/copilot.status")" == "0" ]]
[[ -s "$tmp/council/copilot.attempt2.md" ]]
[[ "$(stat -c '%a' "$tmp/council")" == "700" ]]

mkdir "$tmp/existing"
chmod 755 "$tmp/existing"
if PATH="$tmp/bin:/usr/bin:/bin" "$HEAD" council "$tmp/review.txt" "$tmp/existing" >/dev/null 2>&1; then
  echo "existing output directory was accepted" >&2
  exit 1
fi
[[ "$(stat -c '%a' "$tmp/existing")" == "755" ]] || {
  echo "existing output directory permissions changed" >&2
  exit 1
}

echo "AVALHLA_HEAD_TEST_OK"
