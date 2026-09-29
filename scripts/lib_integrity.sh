#!/usr/bin/env bash
# Shared SHA-256 integrity primitive for addressable Avalhla objects.
# Hashes identify/verify exact bytes. They do not define meaning or authority.
set -Eeuo pipefail

ava_integrity_sha256_valid() {
    local value="${1:-}"
    [[ "$value" =~ ^[0-9a-fA-F]{64}$ ]]
}

ava_integrity_sha256_file() {
    local file="${1:-}"

    [[ -n "$file" ]] || {
        printf '%s\n' 'integrity: file path required' >&2
        return 1
    }
    [[ -f "$file" ]] || {
        printf 'integrity: not a regular file: %s\n' "$file" >&2
        return 1
    }
    command -v sha256sum >/dev/null 2>&1 || {
        printf '%s\n' 'integrity: sha256sum is required' >&2
        return 1
    }

    sha256sum -- "$file" | awk '{print $1}'
}

ava_integrity_sha256_bytes() {
    local value="${1:-}"

    command -v sha256sum >/dev/null 2>&1 || {
        printf '%s\n' 'integrity: sha256sum is required' >&2
        return 1
    }

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
