#!/usr/bin/env bash
# cli_edge_cases.sh -- edge-case tests for the Avalhla CLI scripts.
# Covers: bad args, missing config, empty input, permission errors.
# Offline: no Ollama, no canonical root, no fzf required.
# Usage: tests/cli_edge_cases.sh   (or: make test)
set -uo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
S="$ROOT/scripts"
PASS=0; FAIL=0; SKIP=0

SANDBOX="$(mktemp -d)"
chmod 755 "$SANDBOX"
trap 'chmod -R u+rwX "$SANDBOX" 2>/dev/null; rm -rf "$SANDBOX"' EXIT

# Isolated env: empty HOME, no PATH extras that could leak real state.
export HOME="$SANDBOX/home"
mkdir -p "$HOME"
unset AVA_TASKS_FILE AVA_TASKS_REPO

# run <cmd...> : captures OUT, ERR, RC; stdin is empty.
run() {
    OUT="$("$@" </dev/null 2>"$SANDBOX/.err")"; RC=$?
    ERR="$(cat "$SANDBOX/.err")"
}

ok()   { PASS=$((PASS + 1)); printf '  ok    %s\n' "$1"; }
bad()  { FAIL=$((FAIL + 1)); printf '  FAIL  %s\n        rc=%s out=%q err=%q\n' "$1" "$RC" "$OUT" "$ERR"; }
skip() { SKIP=$((SKIP + 1)); printf '  skip  %s (%s)\n' "$1" "$2"; }

# expect <name> <rc> <stream:out|err|any> <substring>
expect() {
    local name="$1" want_rc="$2" stream="$3" needle="$4" hay
    case "$stream" in out) hay="$OUT" ;; err) hay="$ERR" ;; *) hay="$OUT$ERR" ;; esac
    if [[ "$RC" == "$want_rc" && "$hay" == *"$needle"* ]]; then ok "$name"; else bad "$name"; fi
}

# Run a command as an unprivileged user (permission tests are meaningless as root).
as_user() {
    if [[ "$(id -u)" -ne 0 ]]; then "$@"
    else setpriv --reuid=nobody --regid=nogroup --clear-groups env HOME="$HOME" "$@"
    fi
}
can_drop() { [[ "$(id -u)" -ne 0 ]] || command -v setpriv >/dev/null 2>&1; }

echo "== bad args =="
run "$S/ava-pick" --bogus;          expect "ava-pick unknown flag -> rc 2"        2 err "unknown arg: --bogus"
run "$S/ava-pick" -n;               expect "ava-pick -n without value -> rc 2"    2 err "-n needs a positive integer"
run "$S/ava-pick" -n abc;           expect "ava-pick -n non-numeric -> rc 2"      2 err "-n needs a positive integer"
run "$S/ava-pick" -n 0;             expect "ava-pick -n 0 -> rc 2"                2 err "-n needs a positive integer"
run "$S/ava-pick" --help;           expect "ava-pick --help -> rc 0"              0 out "usage: ava-pick"
run "$S/ava-doc";                   expect "ava-doc no file -> rc 2"              2 err "usage: ava-doc"
run "$S/ava-doc" -o;                expect "ava-doc -o without value -> rc 2"     2 err "-o needs a path"
run "$S/ava-doc" a b;               expect "ava-doc extra arg -> rc 2"            2 err "extra arg: b"
run "$S/ava-mem" --help;            expect "ava-mem --help -> rc 0"               0 out "usage: ava-mem"
run "$S/ava-search" --help;         expect "ava-search --help -> rc 0"            0 out "usage: ava-search"

echo "== missing config =="
run env AVA_TASKS_FILE="$SANDBOX/nope.txt" "$S/ava-pick"
expect "ava-pick missing tasks file -> rc 1"   1 err "no tasks file at $SANDBOX/nope.txt"
run "$S/ava-doc" "$SANDBOX/nope.sh";      expect "ava-doc missing file -> rc 1"    1 err "not a file"
run "$S/ava-doc" "$SANDBOX";              expect "ava-doc dir as file -> rc 1"     1 err "not a file"
run "$S/ava-mem";                         expect "ava-mem no memory dir -> rc 0"   0 out "conversations : 0 files"
run "$S/ava-mem" --json
if [[ "$RC" == 0 ]] && jq -e '.conversations == 0 and .kb == 0' >/dev/null 2>&1 <<<"$OUT"
then ok "ava-mem --json no memory dir -> zeros"; else bad "ava-mem --json no memory dir -> zeros"; fi
if command -v fzf >/dev/null 2>&1; then
    run "$S/ava-search";                  expect "ava-search no conv dir -> rc 1"  1 err "no conversation dir"
else
    run "$S/ava-search";                  expect "ava-search no fzf -> rc 1"       1 err "fzf not installed"
fi
if [[ ! -x /var/home/VVgbon/Avalhla/scripts/lib_context.sh ]]; then
    run "$S/ai-read" foo;                 expect "ai-read no dispatcher -> rc 1"   1 err "dispatcher unavailable"
else
    skip "ai-read no dispatcher" "canonical root present"
fi

echo "== empty input =="
: > "$SANDBOX/empty.txt"
run env AVA_TASKS_FILE="$SANDBOX/empty.txt" "$S/ava-pick"
expect "ava-pick empty tasks file -> rc 0"     0 out "no active tasks"
printf '# only comments\n- [x] 5 1 done already\n' > "$SANDBOX/done.txt"
run env AVA_TASKS_FILE="$SANDBOX/done.txt" "$S/ava-pick" --done
expect "ava-pick --done nothing active -> rc 0" 0 out "no active tasks"
run "$S/lib_redact.sh";                   expect "lib_redact empty stdin -> empty" 0 out ""
[[ -z "$OUT" ]] || bad "lib_redact empty stdin produced output"
run "$S/lib_output_gate.sh";              expect "output_gate empty stdin -> rc 0" 0 out ""
[[ -z "$OUT" ]] || bad "output_gate empty stdin produced output"
run bash -c 'printf "token=abc123\n" | "$1"' _ "$S/lib_redact.sh"
expect "lib_redact still redacts"          0 out "token=[REDACTED]"
mkdir -p "$HOME/.ai-memory/conversations"
: > "$HOME/.ai-memory/conversations/2026-11-02.jsonl"
run "$S/ava-mem" --quiet;                 expect "ava-mem empty jsonl -> 1 talk"   0 out "1 talks"

echo "== permission errors =="
if can_drop; then
    printf -- '- [ ] 5 1 secret task\n' > "$SANDBOX/locked.txt"
    chmod 000 "$SANDBOX/locked.txt"
    run as_user env AVA_TASKS_FILE="$SANDBOX/locked.txt" "$S/ava-pick"
    expect "ava-pick unreadable tasks -> rc 1"  1 err "cannot read tasks file"

    mkdir -p "$SANDBOX/ro"
    printf -- '- [ ] 5 1 keep me\n' > "$SANDBOX/ro/tasks.txt"
    chmod 444 "$SANDBOX/ro/tasks.txt"; chmod 555 "$SANDBOX/ro"
    run as_user env AVA_TASKS_FILE="$SANDBOX/ro/tasks.txt" "$S/ava-pick" --done
    expect "ava-pick --done read-only -> rc 1"  1 err "cannot write tasks file"
    if grep -qF -- '- [ ] 5 1 keep me' "$SANDBOX/ro/tasks.txt"
    then ok "ava-pick --done read-only leaves file intact"
    else bad "ava-pick --done read-only leaves file intact"; fi

    run as_user env AVA_TASKS_FILE="$SANDBOX/ro/tasks.txt" "$S/ava-pick"
    expect "ava-pick list read-only still works" 0 out "keep me"

    mkdir -p "$SANDBOX/lockedmem/.ai-memory/knowledge-base"
    touch "$SANDBOX/lockedmem/.ai-memory/knowledge-base/a.md"
    chmod 000 "$SANDBOX/lockedmem/.ai-memory/knowledge-base"
    run as_user env HOME="$SANDBOX/lockedmem" "$S/ava-mem" --quiet
    expect "ava-mem unreadable kb dir -> rc 0"  0 out "kb 0"

    printf 'x\n' > "$SANDBOX/noread.sh"; chmod 000 "$SANDBOX/noread.sh"
    run as_user "$S/ava-doc" "$SANDBOX/noread.sh"
    expect "ava-doc unreadable file -> rc 1"    1 err "cannot read"
else
    skip "permission tests" "running as root without setpriv"
fi

echo ""
echo "pass=$PASS fail=$FAIL skip=$SKIP"
[[ "$FAIL" -eq 0 ]]
