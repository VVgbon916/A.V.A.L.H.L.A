#!/usr/bin/env bash
set -Eeuo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# shellcheck source=scripts/lib_runtime.sh
source "$HERE/lib_runtime.sh"
# shellcheck source=scripts/lib_safety.sh
source "$HERE/lib_safety.sh"
# shellcheck source=scripts/lib_redact.sh
source "$HERE/lib_redact.sh"


AVA_CONTEXT_MAX_BYTES="${AVA_CONTEXT_MAX_BYTES:-65536}"
AVA_CONTEXT_MAX_LINES="${AVA_CONTEXT_MAX_LINES:-200}"
AVA_CONTEXT_MAX_GREP_LINES="${AVA_CONTEXT_MAX_GREP_LINES:-100}"

ava_context_assert_file() {
    local target="$1"
    local real

    [[ -n "$target" ]] || return 1
    real="$(ava_safety_realpath "$target")" || return 1
    ava_safety_assert_context_readable "$real" || return 1

    printf '%s\n' "$real"
}

ava_context_assert_dir() {
    local target="$1"
    local real

    [[ -n "$target" ]] || return 1

    real="$(realpath -e -- "$target" 2>/dev/null || true)"
    [[ -n "$real" ]] || return 1
    [[ -d "$real" ]] || return 1
    ava_safety_under "$real" "$AVA_ROOT" || return 1

    [[ "$(basename -- "$real")" != ".git" ]] || return 1
    ava_safety_sensitive "$real" && return 1

    ava_safety_audit "context-dir" "allow" "$real"
    printf '%s\n' "$real"
}

ava_context_file() {
    local real
    real="$(ava_context_assert_file "$1")" || return 1
    ava_safety_read_file "$real" | ava_redact
}

ava_context_head() {
    local target="$1"
    local bytes="${2:-8192}"
    local real

    [[ "$bytes" =~ ^[0-9]+$ ]] || return 1
    (( bytes > 0 && bytes <= AVA_CONTEXT_MAX_BYTES )) || return 1

    real="$(ava_context_assert_file "$target")" || return 1
    ava_safety_read_head "$real" "$bytes" | ava_redact
}

ava_context_tail() {
    local target="$1"
    local lines="${2:-18}"
    local real
    local size

    [[ "$lines" =~ ^[0-9]+$ ]] || return 1
    (( lines > 0 && lines <= AVA_CONTEXT_MAX_LINES )) || return 1

    real="$(ava_context_assert_file "$target")" || return 1

    size="$(stat -c '%s' -- "$real" 2>/dev/null || echo 0)"
    [[ "$size" =~ ^[0-9]+$ ]] || return 1
    (( size <= AVA_CONTEXT_MAX_BYTES )) || return 1

    tail -n "$lines" -- "$real" | ava_redact
}

ava_context_latest() {
    local dir="$1"
    local suffix="${2:-}"
    local bytes="${3:-1800}"
    local real_dir latest record

    [[ "$bytes" =~ ^[0-9]+$ ]] || return 1
    (( bytes > 0 && bytes <= AVA_CONTEXT_MAX_BYTES )) || return 1

    real_dir="$(ava_context_assert_dir "$dir")" || return 1

    latest=""
    record=""

    if [[ -n "$suffix" ]]; then
        if IFS= read -r -d "" record < <(
            find "$real_dir" \
                -maxdepth 1 \
                -type f \
                -name "*$suffix" \
                -printf '%T@ %p\0' 2>/dev/null |
            sort -z -nr |
            head -z -n1
        ); then
            latest="${record#* }"
        fi
    else
        if IFS= read -r -d "" record < <(
            find "$real_dir" \
                -maxdepth 1 \
                -type f \
                -printf '%T@ %p\0' 2>/dev/null |
            sort -z -nr |
            head -z -n1
        ); then
            latest="${record#* }"
        fi
    fi

    [[ -n "$latest" ]] || return 0
    ava_context_head "$latest" "$bytes"
}

ava_context_recent_jsonl() {
    local dir="$1"
    local lines="${2:-18}"
    local bytes="${3:-2200}"
    local real_dir latest real record

    [[ "$lines" =~ ^[0-9]+$ ]] || return 1
    [[ "$bytes" =~ ^[0-9]+$ ]] || return 1
    (( lines > 0 && lines <= AVA_CONTEXT_MAX_LINES )) || return 1
    (( bytes > 0 && bytes <= AVA_CONTEXT_MAX_BYTES )) || return 1

    real_dir="$(ava_context_assert_dir "$dir")" || return 1

    latest=""
    record=""

    if IFS= read -r -d "" record < <(
        find "$real_dir" \
            -maxdepth 1 \
            -type f \
            -name '*.jsonl' \
            -printf '%T@ %p\0' 2>/dev/null |
        sort -z -nr |
        head -z -n1
    ); then
        latest="${record#* }"
    fi

    [[ -n "$latest" ]] || return 0
    real="$(ava_context_assert_file "$latest")" || return 1

    tail -n "$lines" -- "$real" |
        jq -r 'select(.role? and .content?) | "\(.role): \(.content)"' 2>/dev/null |
        sed -n '1,'"${AVA_CONTEXT_MAX_GREP_LINES}"'p' |
        head -c "$bytes" |
        ava_redact
}

ava_context_many() {
    local target
    local real

    for target in "$@"; do
        [[ -n "$target" ]] || continue

        if real="$(ava_context_assert_file "$target" 2>/dev/null)"; then
            printf '%s\n' "--- $(basename -- "$real") ---"
            ava_safety_read_head "$real" 900 | ava_redact
        fi
    done
}

ava_context_ls() {
    local dir="$1"
    local real

    real="$(ava_context_assert_dir "$dir")" || return 1

    find "$real" \
        -maxdepth 1 \
        -mindepth 1 \
        ! -name '.git' \
        -printf '%f\n' |
        LC_ALL=C sort
}

ava_context_tree() {
    local dir="$1"
    local real

    real="$(ava_context_assert_dir "$dir")" || return 1

    if command -v tree >/dev/null 2>&1; then
        tree -L 2 -a --noreport -I '.git' "$real" 2>/dev/null
    else
        find "$real" \
            -maxdepth 2 \
            ! -path '*/.git' \
            ! -path '*/.git/*' |
            sort
    fi
}

ava_context_grep() {
    local pattern="$1"
    local dir="$2"
    local real
    local tmp
    local file
    local safe
    local matches
    local rc
    local count

    [[ -n "$pattern" ]] || return 1
    real="$(ava_context_assert_dir "$dir")" || return 1

    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' RETURN

    while IFS= read -r -d '' file; do
        safe="$(ava_context_assert_file "$file" 2>/dev/null || true)"
        [[ -n "$safe" ]] || continue

        set +e
        matches="$(
            ava_safety_read_file "$safe" 2>/dev/null |
                grep -n -e "$pattern" 2>/dev/null || true
        )"
        rc=$?
        set -e

        case "$rc" in
            0|1) ;;
            *) return "$rc" ;;
        esac

        if [[ -n "$matches" ]]; then
            while IFS= read -r line; do
                printf '%s:%s\n' "$safe" "$line" >>"$tmp"
            done <<< "$matches"
        fi

        count="$(wc -l <"$tmp" | tr -d '[:space:]')"
        [[ "$count" =~ ^[0-9]+$ ]] || return 1
        (( count >= AVA_CONTEXT_MAX_GREP_LINES )) && break
    done < <(
        find "$real" \
            -type f \
            ! -path '*/.git/*' \
            \( \
                -name '*.md' -o \
                -name '*.txt' -o \
                -name '*.sh' -o \
                -name '*.toml' -o \
                -name '*.conf' -o \
                -name '*.yaml' -o \
                -name '*.yml' -o \
                -name '*.json' -o \
                -name '*.Modelfile' -o \
                -name 'Modelfile' \
            \) \
            -print0 2>/dev/null
    )

    sed -n "1,${AVA_CONTEXT_MAX_GREP_LINES}p" "$tmp" | ava_redact
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        file)
            shift
            ava_context_file "$@"
            ;;
        head)
            shift
            ava_context_head "$@"
            ;;
        tail)
            shift
            ava_context_tail "$@"
            ;;
        latest)
            shift
            ava_context_latest "$@"
            ;;
        recent-jsonl)
            shift
            ava_context_recent_jsonl "$@"
            ;;
        many)
            shift
            ava_context_many "$@"
            ;;
        ls)
            shift
            ava_context_ls "$@"
            ;;
        tree)
            shift
            ava_context_tree "$@"
            ;;
        grep)
            shift
            ava_context_grep "$@"
            ;;
        *)
            printf '%s\n' \
                'usage:' \
                '  lib_context.sh file TARGET' \
                '  lib_context.sh head TARGET BYTES' \
                '  lib_context.sh tail TARGET LINES' \
                '  lib_context.sh latest DIR [SUFFIX] [BYTES]' \
                '  lib_context.sh recent-jsonl DIR [LINES] [BYTES]' \
                '  lib_context.sh many TARGET...' \
                '  lib_context.sh ls DIR' \
                '  lib_context.sh tree DIR' \
                '  lib_context.sh grep PATTERN DIR'
            exit 2
            ;;
    esac
fi
