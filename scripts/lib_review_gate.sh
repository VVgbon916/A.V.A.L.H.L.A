#!/usr/bin/env bash
# Review-only structural gate. Does not replace the shared output sanitizer.
set -Eeuo pipefail

ava_review_validate() {
    awk '
    BEGIN {
        count = 0
        failed = 0
        names[1] = "BUGS"
        names[2] = "SECURITY"
        names[3] = "PERF"
        names[4] = "STYLE"
        names[5] = "VERDICT"
    }
    function fail(msg) {
        print "review gate: " msg > "/dev/stderr"
        failed = 1
    }
    function set_section(i, value,    finding) {
        if (i != count + 1) {
            fail("missing, duplicate, or out-of-order section: " names[i])
            return
        }

        count = i
        content[i] = 0
        saw_none[i] = 0

        # Standalone section heading. Content is validated by following lines.
        if (value == "")
            return

        if (i == 5) {
            if (value ~ /^(ship|fix-first|rewrite)$/) {
                content[i] = 1
            } else {
                fail("invalid verdict")
            }
            return
        }

        if (tolower(value) == "none") {
            content[i] = 1
            saw_none[i] = 1
            return
        }

        finding = value
        sub(/^[-*][[:space:]]+/, "", finding)

        if (finding ~ /^[^[:space:]:][^:]*:[0-9]+[[:space:]]+--[[:space:]]+.+[[:space:]]+--[[:space:]]+.+$/) {
            content[i] = 1
        } else {
            fail("malformed finding in " names[i])
        }
    }
    {
        line = $0
        sub(/\r$/, "", line)

        trimmed = line
        sub(/^[[:space:]]+/, "", trimmed)
        sub(/[[:space:]]+$/, "", trimmed)

        if (trimmed == "")
            next

        heading = trimmed
        sub(/^#+[[:space:]]*/, "", heading)
        sub(/[[:space:]]*:?[[:space:]]*$/, "", heading)
        upper = toupper(heading)

        matched = 0

        for (i = 1; i <= 5; i++) {
            name = names[i]

            if (upper == name) {
                matched = 1
                set_section(i, "")
                break
            }

            prefix = name ":"
            if (toupper(substr(trimmed, 1, length(prefix))) == prefix) {
                value = trimmed
                sub(/^[^:]+:[[:space:]]*/, "", value)
                set_section(i, value)
                matched = 1
                break
            }
        }

        if (matched)
            next

        if (count == 0) {
            fail("content before first section")
            next
        }

        if (count == 5) {
            if (content[5] != 0) {
                fail("content after verdict")
                next
            }
            if (trimmed ~ /^(ship|fix-first|rewrite)$/) {
                content[5] = 1
                next
            }

            fail("invalid verdict")
            next
        }

        if (count < 5) {
            if (tolower(trimmed) == "none") {
                if (content[count] != 0)
                    fail("mixed none and findings in " names[count])
                content[count] = 1
                saw_none[count] = 1
                next
            }

            if (trimmed ~ /^[-*][[:space:]]+/) {
                finding = trimmed
                sub(/^[-*][[:space:]]+/, "", finding)

                if (finding ~ /^[^[:space:]:][^:]*:[0-9]+[[:space:]]+--[[:space:]]+.+[[:space:]]+--[[:space:]]+.+$/) {
                    if (saw_none[count])
                        fail("mixed none and findings in " names[count])
                    content[count] = 1
                    next
                }
            }

            fail("malformed finding in " names[count])
            next
        }

        fail("content after verdict")
    }
    END {
        if (count != 5) {
            fail("expected exactly five ordered sections")
        }

        for (i = 1; i <= 5; i++) {
            if (!content[i])
                fail("empty section " names[i])
        }

        exit failed
    }'
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    ava_review_validate
fi
