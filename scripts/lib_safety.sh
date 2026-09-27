#!/usr/bin/env bash
# =============================================================================
# lib_safety.sh
#
# Deterministic Avalhla safety boundary.
#
# This file intentionally does NOT ask an LLM whether an operation is safe.
# Policy lives here, outside the model.
#
# Safe defaults:
#   read                  = bounded
#   inference            = bounded
#   memory write         = bounded
#   local Ollama API     = allowed
#   external network     = denied
#   arbitrary shell      = denied
#   system mutation      = denied
#   external side effect = denied
# =============================================================================

set -Eeuo pipefail

# ---------------------------------------------------------------------------
# Capability policy
# ---------------------------------------------------------------------------

ava_safety_capability() {
    case "${1:-}" in
        read)
            return 0
            ;;
        inference)
            return 0
            ;;
        memory-write)
            return 0
            ;;
        local-api)
            return 0
            ;;
        external-network|shell|system-mutation|external-side-effect)
            return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Canonical path helpers
# ---------------------------------------------------------------------------

ava_safety_realpath() {
    realpath -e -- "$1" 2>/dev/null
}

ava_safety_under() {
    local child root

    # Targets may not exist yet.  The old implementation used
    # realpath -e and therefore rejected legitimate future files.
    # realpath -m canonicalizes the complete lexical path while
    # resolving existing symlink components.
    child="$(realpath -m -- "$1" 2>/dev/null || true)"
    root="$(realpath -m -- "$2" 2>/dev/null || true)"

    [[ -n "$child" && -n "$root" ]] || return 1

    [[ "$child" == "$root" || "$child" == "$root/"* ]]
}

# ---------------------------------------------------------------------------
# Sensitive-file denylist
#
# This is deliberately conservative.
# A file can be inside an otherwise trusted directory and still be unsafe
# to place into model context.
# ---------------------------------------------------------------------------

ava_safety_sensitive() {
    local path base

    # A destination may not exist yet.  Security classification must
    # still work for future files, so canonicalize lexically rather
    # than treating "does not exist" as "sensitive".
    path="$(realpath -m -- "$1" 2>/dev/null || true)"
    [[ -n "$path" ]] || return 0

    base="$(basename "$path")"

    case "$base" in
        .env|.env.*)
            return 0
            ;;
        .netrc|.npmrc|.pypirc)
            return 0
            ;;
        .dockerconfigjson)
            return 0
            ;;
        credentials|credentials.*)
            return 0
            ;;
        service-account*.json)
            return 0
            ;;
        *secret*.json|*secret*.yaml|*secret*.yml)
            return 0
            ;;
        *token*.json|*token*.yaml|*token*.yml)
            return 0
            ;;
        id_rsa|id_rsa.*|id_ed25519|id_ed25519.*)
            return 0
            ;;
        *.pem|*.key|*.p12|*.pfx)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Security audit log
#
# We record WHAT happened without recording raw file contents.
# Target is represented by a SHA-256 path fingerprint.
# ---------------------------------------------------------------------------

ava_safety_audit() {
    local action="${1:-unknown}"
    local result="${2:-unknown}"
    local target="${3:-}"

    local audit_dir="${AVA_SAFETY_AUDIT_DIR:-$AVA_REALITY_DIR/security}"
    local audit_file="$audit_dir/events.jsonl"
    local target_hash=""

    mkdir -p "$audit_dir"
    chmod 700 "$audit_dir"

    if [[ -n "$target" ]]; then
        target_hash="$(
            printf '%s' "$target" |
                sha256sum |
                awk '{print $1}'
        )"
    fi

    jq -cn \
        --arg ts "$(date -Iseconds)" \
        --arg action "$action" \
        --arg result "$result" \
        --arg target_hash "$target_hash" \
        --arg pid "$$" \
        '{
            ts:$ts,
            action:$action,
            result:$result,
            target_hash:$target_hash,
            pid:($pid|tonumber)
        }' >> "$audit_file"

    chmod 600 "$audit_file"
}

# ---------------------------------------------------------------------------
# READ boundary
# ---------------------------------------------------------------------------

ava_safety_assert_readable() {
    local target="$1"
    local real

    real="$(ava_safety_realpath "$target")" || {
        ava_safety_audit "read" "deny-not-found" "$target"
        echo "X safety: target does not resolve" >&2
        return 1
    }

    if ava_safety_sensitive "$real"; then
        ava_safety_audit "read" "deny-sensitive" "$real"
        echo "X safety: sensitive file denied" >&2
        return 1
    fi

    ava_safety_audit "read" "allow" "$real"
    return 0
}

# ---------------------------------------------------------------------------
# LEARN / INDEX boundary
#
# Learning may only originate from:
#   - Avalhla repo
#   - auto-read dropbox
#   - existing knowledge-base
#
# It may NOT arbitrarily walk the user's home directory, /etc, /var, etc.
# ---------------------------------------------------------------------------

ava_safety_assert_learn_source() {
    local target="$1"
    local real

    real="$(ava_safety_realpath "$target")" || {
        ava_safety_audit "learn-source" "deny-not-found" "$target"
        echo "X safety: learning source does not resolve" >&2
        return 1
    }

    if ava_safety_sensitive "$real"; then
        ava_safety_audit "learn-source" "deny-sensitive" "$real"
        echo "X safety: sensitive learning source denied" >&2
        return 1
    fi

    if ava_safety_under "$real" "$AVA_ROOT" ||
       ava_safety_under "$real" "$AVA_AUTOREAD_DIR" ||
       ava_safety_under "$real" "$AVA_KNOWLEDGE_DIR"; then
        ava_safety_audit "learn-source" "allow" "$real"
        return 0
    fi

    ava_safety_audit "learn-source" "deny-outside-root" "$real"
    echo "X safety: learning source outside approved roots" >&2
    return 1
}

ava_safety_assert_learn_file() {
    local target="$1"

    if ava_safety_sensitive "$target"; then
        ava_safety_audit "learn-file" "deny-sensitive" "$target"
        return 1
    fi

    return 0
}

# ---------------------------------------------------------------------------

# TRUSTED CONTEXT READ boundary
#
# This is the read gate for persistent content that may enter
# Avalhla model context.
#
# Rules:
#   - target must resolve to an existing regular file
#   - resolved target must remain under the trusted Avalhla root
#   - sensitive filenames are denied
#   - file size is bounded
#   - the read is audited
#
# This does not claim the content is true.
# It only establishes that the path is authorized for context loading.

ava_safety_assert_context_readable() {
    local target="$1"
    local real size max_bytes

    max_bytes="${AVA_SAFETY_MAX_READ_BYTES:-65536}"

    real="$(ava_safety_realpath "$target")" || {
        ava_safety_audit "context-read" "deny-not-found" "$target"
        echo "X safety: trusted read target does not resolve" >&2
        return 1
    }

    [[ -f "$real" ]] || {
        ava_safety_audit "context-read" "deny-not-regular" "$real"
        echo "X safety: trusted read target is not a regular file" >&2
        return 1
    }

    if ava_safety_sensitive "$real"; then
        ava_safety_audit "context-read" "deny-sensitive" "$real"
        echo "X safety: sensitive context read denied" >&2
        return 1
    fi

    if ! ava_safety_under "$real" "$AVA_ROOT"; then
        ava_safety_audit "context-read" "deny-outside-root" "$real"
        echo "X safety: context read outside Avalhla root" >&2
        return 1
    fi

    size="$(stat -c '%s' -- "$real" 2>/dev/null || echo 0)"

    if [[ ! "$size" =~ ^[0-9]+$ ]]; then
        ava_safety_audit "context-read" "deny-size-unresolved" "$real"
        echo "X safety: context read size could not be resolved" >&2
        return 1
    fi

    if (( size > max_bytes )); then
        ava_safety_audit "context-read" "deny-oversized" "$real"
        echo "X safety: context read exceeds ${max_bytes} bytes" >&2
        return 1
    fi

    ava_safety_audit "context-read" "allow" "$real"
    return 0
}

ava_safety_read_file() {
    local target="$1"
    local real

    real="$(ava_safety_realpath "$target")" || return 1
    ava_safety_assert_context_readable "$real" || return 1

    cat -- "$real"
}

ava_safety_read_head() {
    local target="$1"
    local bytes="${2:-8192}"
    local real max_bytes

    max_bytes="${AVA_SAFETY_MAX_READ_BYTES:-65536}"

    [[ "$bytes" =~ ^[0-9]+$ ]] || {
        echo "X safety: invalid context read size" >&2
        return 1
    }

    (( bytes <= max_bytes )) || {
        echo "X safety: requested context read exceeds safety limit" >&2
        return 1
    }

    real="$(ava_safety_realpath "$target")" || return 1
    ava_safety_assert_context_readable "$real" || return 1

    head -c "$bytes" -- "$real"
}

# MEMORY WRITE boundary
# ---------------------------------------------------------------------------

ava_safety_assert_memory_write() {
    local target="$1"
    local real root_real

    real="$(realpath -m -- "$target" 2>/dev/null || true)"
    root_real="$(realpath -m -- "$AVA_MEMORY_DIR" 2>/dev/null || true)"

    [[ -n "$real" && -n "$root_real" ]] || {
        ava_safety_audit "memory-write" "deny-unresolved" "$target"
        echo "X safety: memory write path does not resolve" >&2
        return 1
    }

    if ! ava_safety_under "$real" "$root_real"; then
        ava_safety_audit "memory-write" "deny-outside-memory" "$real"
        echo "X safety: memory write outside memory root" >&2
        return 1
    fi

    if ava_safety_sensitive "$real"; then
        ava_safety_audit "memory-write" "deny-sensitive" "$real"
        echo "X safety: sensitive memory target denied" >&2
        return 1
    fi

    ava_safety_audit "memory-write" "allow" "$real"
    return 0
}

ava_safety_assert_ingest_source() {
    local target="$1"
    local real

    real="$(ava_safety_realpath "$target")" || {
        ava_safety_audit "ingest-source" "deny-not-found" "$target"
        echo "X safety: ingest source does not resolve" >&2
        return 1
    }

    if ava_safety_sensitive "$real"; then
        ava_safety_audit "ingest-source" "deny-sensitive" "$real"
        echo "X safety: sensitive ingest denied" >&2
        return 1
    fi

    ava_safety_audit "ingest-source" "allow" "$real"
    return 0
}

ava_safety_write_file() {
    local target="$1"
    local content="$2"

    ava_safety_assert_memory_write "$target" || return 1

    local parent
    parent="$(dirname -- "$target")"
    mkdir -p -- "$parent"

    ava_safety_assert_memory_write "$target" || return 1

    local lock_file="$target.lock"
    local tmp=""
    local mode=""
    local rc=0

    exec 9>"$lock_file"
    flock -x 9

    # Re-check after acquiring the lock to reduce TOCTOU risk.
    ava_safety_assert_memory_write "$target" || {
        rc=1
    }

    if (( rc == 0 )); then
        if [[ -e "$target" && ! -L "$target" ]]; then
            mode="$(stat -c '%a' -- "$target" 2>/dev/null || true)"
        fi

        tmp="$(mktemp -- "$parent/.ava-write.XXXXXX")" || rc=1

        if (( rc == 0 )); then
            if [[ -n "$mode" ]]; then
                chmod "$mode" "$tmp" || rc=1
            fi
        fi

        if (( rc == 0 )); then
            if ! printf '%s' "$content" > "$tmp"; then
                rc=1
            fi
        fi

        if (( rc == 0 )); then
            if ! ava_safety_assert_memory_write "$target"; then
                rc=1
            fi
        fi

        if (( rc == 0 )); then
            if ! mv -f -- "$tmp" "$target"; then
                rc=1
            fi
            tmp=""
        fi
    fi

    if [[ -n "$tmp" ]]; then
        rm -f -- "$tmp"
    fi

    if (( rc == 0 )); then
        ava_safety_audit "memory-write" "commit" "$target" || rc=1
    fi

    flock -u 9
    exec 9>&-
    return "$rc"
}

ava_safety_append_file() {
    local target="$1"
    local content="$2"

    ava_safety_assert_memory_write "$target" || return 1

    local parent
    parent="$(dirname -- "$target")"
    mkdir -p -- "$parent"

    ava_safety_assert_memory_write "$target" || return 1

    local lock_file="$target.lock"
    local rc=0

    exec 9>"$lock_file"
    flock -x 9

    ava_safety_assert_memory_write "$target" || rc=1

    if (( rc == 0 )); then
        if ! printf '%s' "$content" >> "$target"; then
            rc=1
        fi
    fi

    if (( rc == 0 )); then
        ava_safety_audit "memory-append" "commit" "$target" || rc=1
    fi

    flock -u 9
    exec 9>&-
    return "$rc"
}

# ---------------------------------------------------------------------------
# SELF TEST
# ---------------------------------------------------------------------------

ava_safety_self_test() {
    local failures=0
    local tmp_root=""
    local tmp_memory=""
    local tmp_outside=""
    local safe_file=""
    local sensitive_file=""
    local key_file=""
    local inside_file=""
    local safe_link=""
    local escape_link=""
    local traversal_file=""
    local memory_future=""
    local memory_actual=""
    local memory_sensitive=""
    local memory_escape_link=""
    local outside_file=""
    local bytes=""
    local rel_outside=""

    pass() {
        printf '  [ OK ] %s\n' "$1"
    }

    fail() {
        printf '  [FAIL] %s\n' "$1"
        failures=$((failures + 1))
    }

    printf '%s\n' '-- public safety self-test contract --'
    printf '%s\n' '  contract: ava-safety --self-test'
    printf '%s\n' '  runtime-root: canonical'
    printf '%s\n' '  context-read: bounded / root-constrained / sensitive-deny'

    printf '%s\n' '-- capability matrix --'

    for cap in read inference memory-write local-api; do
        if ava_safety_capability "$cap"; then
            pass "allow $cap"
        else
            fail "allow $cap"
        fi
    done

    for cap in external-network shell system-mutation external-side-effect; do
        if ava_safety_capability "$cap"; then
            fail "deny $cap"
        else
            pass "deny $cap"
        fi
    done

    printf '%s\n' '-- canonical isolation --'

    if [[ "$AVA_ROOT" == "/var/home/VVgbon/Avalhla" ]]; then
        pass "canonical root is /var/home/VVgbon/Avalhla"
    else
        fail "canonical root was weakened or redirected: $AVA_ROOT"
    fi

    if [[ "$AVA_MEMORY_DIR" == "/var/home/VVgbon/Avalhla/memory" ]]; then
        pass "canonical memory is /var/home/VVgbon/Avalhla/memory"
    else
        fail "canonical memory was weakened or redirected: $AVA_MEMORY_DIR"
    fi

    printf '%s\n' '-- isolated read/context tests --'

    tmp_root="$(mktemp -d "$AVA_ROOT/.ava-safety-self-test.XXXXXX")" || {
        fail "create isolated repo-root test directory"
        return 1
    }

    tmp_memory="$(mktemp -d "$AVA_MEMORY_DIR/.ava-safety-self-test.XXXXXX")" || {
        fail "create isolated memory test directory"
        rm -rf -- "$tmp_root"
        return 1
    }

    tmp_outside="$(mktemp -d)" || {
        fail "create isolated outside-root test directory"
        rm -rf -- "$tmp_root" "$tmp_memory"
        return 1
    }

    trap 'rm -rf -- "${tmp_root:-}" "${tmp_memory:-}" "${tmp_outside:-}"' EXIT

    safe_file="$tmp_root/safe.txt"
    sensitive_file="$tmp_root/.env"
    key_file="$tmp_root/id_ed25519"
    inside_file="$tmp_root/inside.txt"
    safe_link="$tmp_root/safe-link.txt"
    escape_link="$tmp_root/escape-link.txt"
    outside_file="$tmp_outside/outside.txt"

    printf 'safe-context\n' > "$safe_file"
    printf 'SECRET\n' > "$sensitive_file"
    printf 'PRIVATE-KEY\n' > "$key_file"
    printf 'inside-context\n' > "$inside_file"
    printf 'outside-context\n' > "$outside_file"

    ln -s -- "$(basename "$inside_file")" "$safe_link"
    ln -s -- "$outside_file" "$escape_link"

    rel_outside="$(realpath -m --relative-to="$AVA_ROOT" "$outside_file")"
    traversal_file="$AVA_ROOT/$rel_outside"

    if ava_safety_assert_context_readable "$safe_file"; then
        pass "context allow safe file"
    else
        fail "context allow safe file"
    fi

    if ava_safety_assert_context_readable "$sensitive_file"; then
        fail "context deny sensitive .env"
    else
        pass "context deny sensitive .env"
    fi

    if ava_safety_assert_context_readable "$key_file"; then
        fail "context deny private key"
    else
        pass "context deny private key"
    fi

    if ava_safety_assert_context_readable "$outside_file"; then
        fail "context deny outside-root file"
    else
        pass "context deny outside-root file"
    fi

    if ava_safety_assert_context_readable "$traversal_file"; then
        fail "context deny traversal path"
    else
        pass "context deny traversal path"
    fi

    if ava_safety_assert_context_readable "$escape_link"; then
        fail "context deny escaping symlink"
    else
        pass "context deny escaping symlink"
    fi

    if ava_safety_assert_context_readable "$safe_link"; then
        pass "context allow canonical in-root symlink"
    else
        fail "context allow canonical in-root symlink"
    fi

    if [[ "$(ava_safety_read_file "$safe_file" 2>/dev/null)" == "safe-context" ]]; then
        pass "trusted context read returns safe content"
    else
        fail "trusted context read returns safe content"
    fi

    if [[ "$(ava_safety_read_file "$escape_link" 2>/dev/null)" == "" ]]; then
        pass "trusted context read blocks escaping symlink"
    else
        fail "trusted context read blocks escaping symlink"
    fi

    bytes="$(ava_safety_read_head "$safe_file" 4 2>/dev/null | wc -c | tr -d '[:space:]')"
    if [[ "$bytes" =~ ^[0-9]+$ ]] && (( bytes <= 4 )); then
        pass "trusted context read is byte-bounded"
    else
        fail "trusted context read is byte-bounded"
    fi

    printf '%s\n' '-- isolated memory-write tests --'

    memory_future="$tmp_memory/future.txt"
    memory_actual="$tmp_memory/actual.txt"
    memory_sensitive="$tmp_memory/.env"
    memory_escape_link="$tmp_memory/escape-write.txt"

    if ava_safety_assert_memory_write "$memory_future"; then
        pass "memory-write allow future in-root target"
    else
        fail "memory-write allow future in-root target"
    fi

    if ava_safety_assert_memory_write "$outside_file"; then
        fail "memory-write deny outside-memory target"
    else
        pass "memory-write deny outside-memory target"
    fi

    if ava_safety_assert_memory_write "$memory_sensitive"; then
        fail "memory-write deny sensitive target"
    else
        pass "memory-write deny sensitive target"
    fi

    ln -s -- "$outside_file" "$memory_escape_link"

    if ava_safety_assert_memory_write "$memory_escape_link"; then
        fail "memory-write deny escaping symlink"
    else
        pass "memory-write deny escaping symlink"
    fi

    if ava_safety_write_file "$memory_actual" "write-test"; then
        if [[ "$(cat -- "$memory_actual" 2>/dev/null)" == "write-test" ]]; then
            pass "memory-write commit stays inside canonical memory"
        else
            fail "memory-write commit content mismatch"
        fi
    else
        fail "memory-write commit allowed"
    fi

    if ava_safety_append_file "$memory_actual" $'\nappend-test'; then
        if grep -qx 'append-test' "$memory_actual" 2>/dev/null; then
            pass "memory append stays inside canonical memory"
        else
            fail "memory append content mismatch"
        fi
    else
        fail "memory append allowed"
    fi

    printf '%s\n' '-- self-test result --'

    if (( failures == 0 )); then
        printf '%s\n' 'SELF_TEST_STATUS=PASS'
        printf '%s\n' 'result: SAFETY SELF-TEST CLEAN'
        return 0
    fi

    printf 'SELF_TEST_STATUS=FAIL failures=%d\n' "$failures"
    printf 'result: %d SAFETY FAILURE(S)\n' "$failures"
    return 1
}
