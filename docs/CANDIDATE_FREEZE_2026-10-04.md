# Candidate Freeze — 2026-10-04

Evidence artifact. Derived report only. Does not integrate, publish, or
authorize anything. Produced to satisfy `docs/HANDOFF.md` `05 NEXT`: freeze
the current Codex candidate exactly before requesting Claude's read-only
review.

## Scope

Worktree: `/var/home/VVgbon/.local/state/avalhla-worktrees/codex-build`
Branch: `codex/avalhla-build-2026-10-03`

## Identity

- HEAD: `61a2148587895aa27cf59c24290bc224f06db96d`
- Merge-base with `origin/main`: `f2f09aacdd176e2f1a1a150eb70d704bfcc973d2`
- Tracked-file diff vs HEAD: 26 files changed, 685 insertions(+), 293 deletions(-)
  (uncommitted content changes to already-tracked files; see `git diff HEAD`
  in that worktree for the exact hunks)
- File census: 136 tracked paths + 55 untracked-but-not-ignored paths = 191
  total addressable files at freeze time

## Contradiction found and resolved

`docs/HANDOFF.md` section `01 WHERE` records this repository's (ROOT) `HEAD`
as `61a2148587895aa27cf59c24290bc224f06db96d`. The live ROOT `HEAD` at freeze
time is actually `5414507`, one commit ahead of `61a2148`
(`docs: add Claude Code adapter importing AGENTS.md`). `61a2148` is an
ancestor of ROOT `HEAD`, not a divergence — ROOT and the Codex candidate
share history up to that merge commit, then ROOT advanced by one commit
while the candidate stayed parked at `61a2148`. This freeze record uses the
verified live values, not the stale HANDOFF copy. Per `AGENTS.md` step 08,
this stale note is historical, not current proof; `docs/HANDOFF.md` should
be corrected on its next edit pass.

## Byte-exact manifest

Full per-file `sha256  mode  path` listing (sorted): see
[docs/CANDIDATE_FREEZE_2026-10-04.sha256](/var/home/VVgbon/Avalhla/docs/CANDIDATE_FREEZE_2026-10-04.sha256).
`mode` is the Git blob mode (`100644`/`100755`) for tracked files, or
`untracked:<perm>` for non-ignored untracked files.

Aggregate manifest digest (sha256 of the sorted manifest file above, taken
as a single byte stream):

```
6cfcfb140d6999202d663ffe4b6002a3fedd210ca788baf9b3b7f6b4ed59a3a9
```

Reproduce with, from the candidate worktree:

```
git ls-files -o -c --exclude-standard | while IFS= read -r f; do
  if git ls-files --error-unmatch -- "$f" >/dev/null 2>&1; then
    mode=$(git ls-tree HEAD -- "$f" | awk '{print $1}')
  else
    mode="untracked:$(stat -c '%a' -- "$f")"
  fi
  printf '%s  %s  %s\n' "$(sha256sum -- "$f" | awk '{print $1}')" "$mode" "$f"
done | sort | sha256sum
```

A matching aggregate digest proves the reviewer saw these exact bytes at
these exact paths with these exact modes; a mismatch means the worktree
moved since this freeze and must be re-frozen before review.

## Gate evidence at freeze time

`bash scripts/ava-ci-contract` in the candidate worktree: 130 pass, 0 fail,
including 68 Python tests (`unittest` run inline). Candidate-only evidence;
does not apply to ROOT or any other worktree.

## Next

Per `docs/HANDOFF.md` `05 NEXT`: request Claude's independent, read-only
review of this exact frozen snapshot (verify against the aggregate digest
above before reviewing). This freeze was produced by Copilot/ChatGPT
evidence synthesis; it does not substitute for that review, and it does not
authorize integration. Dawa chooses any integration, provider activation,
model creation, or publication.
