#!/usr/bin/env bash
# Shared SHA-256 integrity primitive for addressable important Avalhla objects.
# SHA-256 identifies/verifies exact bytes. It does not define meaning or authority.
set -Eeuo pipefail

ava_integrity_sha256_valid() {
    local value="${1:-}"
    [[ "$value" =~ ^[0-9a-fA-F]{64}$ ]]
}

ava_integrity_require_tool() {
    command -v sha256sum >/dev/null 2>&1 || {
        printf '%s\n' 'integrity: sha256sum is required' >&2
        return 1
    }
}

ava_integrity_sha256_file() {
    local file="${1:-}"
    [[ -n "$file" && -f "$file" ]] || {
        printf 'integrity: not a regular file: %s\n' "$file" >&2
        return 1
    }
    ava_integrity_require_tool
    sha256sum -- "$file" | awk '{print $1}'
}

ava_integrity_sha256_bytes() {
    local value="${1:-}"
    ava_integrity_require_tool
    printf '%s' "$value" | sha256sum | awk '{print $1}'
}

ava_integrity_verify_file() {
    local file="${1:-}"
    local expected="${2:-}"
    local actual
    ava_integrity_sha256_valid "$expected" || {
        printf '%s\n' 'integrity: expected SHA-256 must be 64 hex characters' >&2
        return 1
    }
    actual="$(ava_integrity_sha256_file "$file")"
    [[ "${actual,,}" == "${expected,,}" ]]
}

ava_integrity_verify_bytes() {
    local value="${1:-}"
    local expected="${2:-}"
    local actual
    ava_integrity_sha256_valid "$expected" || {
        printf '%s\n' 'integrity: expected SHA-256 must be 64 hex characters' >&2
        return 1
    }
    actual="$(ava_integrity_sha256_bytes "$value")"
    [[ "${actual,,}" == "${expected,,}" ]]
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    case "${1:-}" in
        file)
            shift
            [[ $# -eq 1 ]] || { printf '%s\n' 'usage: lib_integrity.sh file PATH' >&2; exit 2; }
            ava_integrity_sha256_file "$1"
            ;;
        bytes)
            shift
            [[ $# -eq 1 ]] || { printf '%s\n' 'usage: lib_integrity.sh bytes VALUE' >&2; exit 2; }
            ava_integrity_sha256_bytes "$1"
            ;;
        verify-file)
            shift
            [[ $# -eq 2 ]] || { printf '%s\n' 'usage: lib_integrity.sh verify-file PATH SHA256' >&2; exit 2; }
            ava_integrity_verify_file "$1" "$2"
            ;;
        *) printf '%s\n' 'usage: lib_integrity.sh {file|bytes|verify-file} ...' >&2; exit 2 ;;
    esac
fi
