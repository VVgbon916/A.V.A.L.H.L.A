#!/usr/bin/env bash
# lib_redact.sh -- shared redactor for Avalhla.
# Single source of truth for what counts as a secret.
# Usage:  source lib_redact.sh ; printf '%s' "$INPUT" | ava_redact
#    or:  printf '%s' "$INPUT" | lib_redact.sh
set -Eeuo pipefail

ava_redact() {
    sed -E \
        -e 's#(Authorization:[[:space:]]*(Bearer|Basic)[[:space:]]+)[^"[:space:]]+#\1[REDACTED]#Ig' \
        -e 's#((-H|--header)([[:space:]]+|=)["'\'']?Authorization:)[^"'\'']*#\1 [REDACTED]#Ig' \
        -e 's#^([[:space:]]*Authorization:[[:space:]]*).*#\1[REDACTED]#Ig' \
        -e 's#((X-[A-Za-z0-9_-]*Token|X-Api-Key):[[:space:]]*)[^"[:space:]]+#\1[REDACTED]#Ig' \
        -e 's#([?&](api[_-]?key|access[_-]?token|auth[_-]?token|password|passwd|secret|token)=)[^&[:space:]"<>]+#\1[REDACTED]#Ig' \
        -e 's#((^|[[:space:]])(--?(password|passwd|secret|token|api-key|access-token|auth-token))[=[:space:]]+)[^[:space:]]+#\1[REDACTED]#Ig' \
        -e '/-----BEGIN [A-Z ]*PRIVATE KEY-----/,/-----END [A-Z ]*PRIVATE KEY-----/s/.*/[REDACTED PRIVATE KEY]/' \
        -e 's#(ghp_|github_pat_|glpat-|xox[baprs]-)[A-Za-z0-9_-]+#[REDACTED]#g' \
        -e 's#sk-[A-Za-z0-9_-]{12,}#[REDACTED]#g' \
        -e 's#(^|[^A-Za-z0-9_])((password|passwd|secret|token|credential|api[_-]?key|access[_-]?token|auth[_-]?token)[=:])[[:space:]]*[^&"[:space:]]+#\1\2[REDACTED]#Ig'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ava_redact
fi
