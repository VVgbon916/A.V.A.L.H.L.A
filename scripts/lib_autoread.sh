#!/usr/bin/env bash
# Caller supplies its existing authorized context reader. No direct generic read.
ava_autoread_load() {
    local directory="$1" budget="$2" reader="$3"
    local file size block total=0
    [[ "$budget" =~ ^[1-9][0-9]*$ ]] || return 2
    [[ -d "$directory" ]] || return 0
    for file in "$directory"/*; do
        [[ -f "$file" ]] || continue
        size="$(stat -c '%s' -- "$file")" || return 1
        if (( size > budget )); then
            printf 'SKIP oversized auto-read: %s\n' "$(basename -- "$file")" >&2
            continue
        fi
        block="$("$reader" "$file")" || {
            printf 'SKIP denied auto-read: %s\n' "$(basename -- "$file")" >&2
            continue
        }
        block="$(printf '\n--- %s ---\n%s\n' "$(basename -- "$file")" "$block")"
        size="$(LC_ALL=C printf '%s' "$block" | wc -c)"
        if (( total + size > budget )); then
            printf 'SKIP budget auto-read: %s\n' "$(basename -- "$file")" >&2
            continue
        fi
        printf '%s' "$block"
        total=$((total + size))
    done
}
