#!/usr/bin/env bash
# Deterministic boundary for preparing data that may enter an Avalhla model prompt.
# This does not make content trustworthy. It labels, bounds, and routes input.
set -Eeuo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# shellcheck source=scripts/lib_runtime.sh
source "$HERE/lib_runtime.sh"
# shellcheck source=scripts/lib_context.sh
source "$HERE/lib_context.sh"
# shellcheck source=scripts/lib_redact.sh
source "$HERE/lib_redact.sh"

AVA_MODEL_INPUT_MAX_BYTES="${AVA_MODEL_INPUT_MAX_BYTES:-65536}"

ava_model_input_assert_bytes() {
    local value="$1"
    local bytes

    bytes="$(printf '%s' "$value" | wc -c)"
    [[ "$bytes" =~ ^[0-9]+$ ]] || return 1
    (( bytes <= AVA_MODEL_INPUT_MAX_BYTES )) || {
        printf '%s\n' "X model-input: payload exceeds ${AVA_MODEL_INPUT_MAX_BYTES} bytes" >&2
        return 1
    }
}

ava_model_input_user() {
    local label="${1:-USER}"
    local value="${2:-}"
    local safe_label

    safe_label="$(printf '%q' "$label")"
    ava_model_input_assert_bytes "$value" || return 1

    printf '%s\n' "[[ BEGIN MODEL INPUT :: USER :: $safe_label ]]"
    printf '%s\n' "$value"
    printf '%s\n' "[[ END MODEL INPUT :: USER :: $safe_label ]]"
}

ava_model_input_context() {
    local label="${1:-CONTEXT}"
    local source="${2:-SOURCE}"
    local value="${3:-}"
    local safe_label
    local safe_source

    ava_model_input_assert_bytes "$value" || return 1

    safe_label="$(printf '%q' "$label")"
    safe_source="$(printf '%q' "$source")"

    printf '%s\n' "[[ BEGIN MODEL INPUT :: CONTEXT :: $safe_label ]]"
    printf '%s\n' "source: $safe_source"
    printf '%s\n' "trust: untrusted-data"
    printf '%s\n' "$value"
    printf '%s\n' "[[ END MODEL INPUT :: CONTEXT :: $safe_label ]]"
}

ava_model_input_file() {
    local label="${1:-FILE}"
    local file="${2:-}"
    local bytes="${3:-8192}"
    local value

    [[ -n "$file" ]] || return 1

    value="$("$HERE/lib_context.sh" head "$file" "$bytes" 2>/dev/null)" || {
        printf '%s\n' "X model-input: file context denied" >&2
        return 1
    }

    ava_model_input_context "$label" "$file" "$value"
}

ava_model_input_stdin() {
    local label="${1:-STDIN}"
    local max_bytes="${2:-$AVA_MODEL_INPUT_MAX_BYTES}"
    local value
    local safe_label

    [[ "$AVA_MODEL_INPUT_MAX_BYTES" =~ ^[1-9][0-9]*$ ]] || {
        printf '%s\n' 'X model-input: configured byte limit must be a positive integer' >&2
        return 1
    }
    [[ "$max_bytes" =~ ^[1-9][0-9]*$ ]] || {
        printf '%s\n' 'X model-input: requested byte limit must be a positive integer' >&2
        return 1
    }
    if (( max_bytes > AVA_MODEL_INPUT_MAX_BYTES )); then
        printf '%s\n' 'X model-input: requested byte limit exceeds configured global limit' >&2
        return 1
    fi

    safe_label="$(printf '%q' "$label")"
    value="$(head -c "$max_bytes")"

    ava_model_input_assert_bytes "$value" || return 1

    printf '%s\n' "[[ BEGIN MODEL INPUT :: STDIN :: $safe_label ]]"
    printf '%s\n' "trust: untrusted-data"
    printf '%s\n' "$value"
    printf '%s\n' "[[ END MODEL INPUT :: STDIN :: $safe_label ]]"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    case "${1:-}" in
        user)
            shift
            ava_model_input_user "${1:-USER}" "${2:-}"
            ;;
        context)
            shift
            ava_model_input_context "${1:-CONTEXT}" "${2:-SOURCE}" "${3:-}"
            ;;
        file)
            shift
            ava_model_input_file "${1:-FILE}" "${2:-}" "${3:-8192}"
            ;;
        stdin)
            shift
            ava_model_input_stdin "${1:-STDIN}" "${2:-$AVA_MODEL_INPUT_MAX_BYTES}"
            ;;
        *)
            echo "usage: lib_model_input.sh {user|context|file|stdin} ..." >&2
            exit 2
            ;;
    esac
fi
