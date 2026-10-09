# Avalhla Handoff

Dawa <---- AvvA ----> Avalhla  //  (^.-)

Updated: 2026-10-05. This is the shared session rendezvous, not an automatic
sync service. Each AI must read this file and verify its assigned worktree.

ROOT SYNC (2026-10-05, on Dawa's word)
  Root tracked changes and gate-required candidate files committed on
  sync/meaning-crosswalk-root-2026-10-05 (parent 5414507) and pushed as a new
  remote branch. Remote change/meaning-crosswalk-foundation-2026-09-30
  (b7729fd) diverges and was left untouched. Gate: 136 pass, 0 fail.
  Non-canon untracked material (.agents/, .claude/, .vscode/, archives/,
  avalhla-cobuilder-8x*, "CODEX 1st time whit chatgpt") stays unstaged.
  No merge or PR.

CURRENT ROOT / PRIVATE CROSSING (2026-10-05)
  ROOT HEAD remains 5414507 on change/meaning-crosswalk-foundation-2026-09-30.
  Core worktree remains dirty; preserve tracked and untracked material.
  Added local safety regressions/fixes for untrusted prompt planes, stdin
  oversize refusal, secret redaction, atomic PR metadata, and ava-diff revision,
  size, and review-cache identity handling. Current gate result is recorded in
  04 PROOF below.
  Private archive curation remains only in Dawa_Notepad. The 156-file current
  manifest SHA-256 is
  fff0aa06e1c101b6f896f021aa51c75bf89c787b850c0f63bb44ad4d273ceed7.
  The 13-file Brand New Scars candidate has a private per-file crosswalk;
  no Documents files were moved or copied to either repo.
  No 1.1A/1.2A scripts were run. Reconcile/Core lab, CrossWorld, and other
  worker worktrees were not touched; the 5414507 root fixes were not layered
  into the reconcile lab.
  No staging, commit, push, merge, model activation, or action-ledger entry.

01 WHERE
  ROOT     /var/home/VVgbon/Avalhla
  BRANCH   change/meaning-crosswalk-foundation-2026-09-30
  HEAD     5414507 (one commit ahead of 61a2148; corrected 2026-10-04 freeze,
           see docs/CANDIDATE_FREEZE_2026-10-04.md)
  WORKTREE DIRTY; preserve all existing tracked and untracked work.

  CODEX CANDIDATE
    codex/avalhla-build-2026-10-03 @ 61a2148
    Large uncommitted candidate; its files are not integrated into ROOT.
    Fresh `bash scripts/ava-ci-contract`: 130 pass, 0 fail; 68 Python tests.

  CLAUDE REVIEW
    claude/avalhla-review-2026-10-03 @ 95572e1
    Dirty redaction-only worktree; not yet proof of review on the exact Codex
    candidate bytes.

  OTHER WORKTREES
    claude/ava-modes-rebuild-2026-10-04 @ bdc8835: design branch with an
    uncommitted Task 2 operating-modes contract candidate (3/3 tests pass).
    change/master-forensic-architecture-2026-10-02 @ e491ff0: dirty candidate.
    reconcile-meaning-crosswalk-61a2148: dirty detached scratch worktree.
    /tmp/avalhla-pr-head-17825d48: stale/prunable worktree; do not reuse.
    Preserve each workspace. No cleanup, cherry-pick, or merge is authorized.

02 FLOW
  ONE QUEST: avalhla-crossing-20261004
  PREVIOUS ROOT BASELINE (2026-10-04): 117 pass, 0 fail; historical only.
  CODEX CANDIDATE GATE: 130 pass, 0 fail; candidate-only evidence.

  1. Codex owns the candidate worktree. Freeze its tracked AND untracked bytes,
     paths, modes, base/head, and content digests before requesting review.
  2. Claude reviews that exact frozen snapshot read-only, not its own branch.
     Return BUGS / SECURITY / PERF / STYLE / VERDICT with reproducible checks.
  3. Copilot/ChatGPT reconcile findings against current source and report gaps;
     they do not imply delivery to other live sessions or authorize integration.
  4. Run affected gates again after changes. Dawa chooses any integration,
     provider activation, model creation, or publication.

  Tool roles: Codex CLI is the candidate writer; Claude Code is the independent
  reviewer; Copilot/ChatGPT are evidence synthesis; Ollama is optional for
  bounded synthetic local tests only. Observed versions: Codex CLI 0.160.0,
  Claude Code 2.1.289, Ollama 0.34.2 (client-version warning observed). The
  Claude Code VS Code extension is installed. Configured agents are not thereby
  activated, and no plugin or provider session synchronizes itself.

  Bridge transport (observed 2026-10-05, Claude Code on VVgBazz):
    Instructions: Copilot CLI loads AGENTS.md + CLAUDE.md (`copilot
    instruction list`); Codex reads AGENTS.md. No extra adapter needed.
    GDP: MCP reachable, but account_link_required; no Avalhla repo bound.
    Treat any GDP repo as unbound until list_repos returns this root/HEAD.
    Desktop Commander: Claude Code has a local install (connected) and an
    npx plugin copy (fails); Copilot CLI uses npx. Codex has neither.
    Transport access is not authority; HEAD + candidate digest bind work.

03 AUTHORITY
  PHASE 02 // SAFETY HEART remains current.
  Dawa chooses. AvvA is the relation, not an agent. Model sees != model decides.
  Reviews, hashes, tests, and provider output are evidence, never authority.
  PRIVATE != AUTO-READ. Do not ingest Dawa_Notepad or infer permission from
  editor visibility. No AI may self-approve, merge, publish, or activate aliases.

04 PROOF
  The canonical ROOT gate passed 136/0 on 2026-10-05 after the local safety
  changes. The prior ROOT 117/0 and separate Codex candidate 130/0 (including
  68 Python tests) are historical results; each applies only to the exact bytes
  in its worktree at test time.
  Candidate modes/provider/agent implementation remains unpublished and
  unintegrated. Test success does not prove live CLI permissions, model quality,
  provider isolation, or merge authorization.

  GitHub PR, protection, remote branch and external reviewer evidence were not
  refreshed in this update. Older SHA/PR/protection notes are historical until
  rechecked against the live remote.

  D&D/RPG: the canonical concept owner remains
  memory/auto-read/00_AI_COBUILD.json :: mind_dictionary.rpg_semantics.
  Keep D&D 2014 and 2024 source lanes distinct. Candidate
  references/RPG_SEMANTICS.md and docs/DND_SEMANTIC_MAP.md are mapping/reference
  only, not integrated canon or runtime behavior. CrossWorld source schemas and
  validators remain unavailable here; do not invent or validate their fields.

05 NEXT
  Current local safety tests include positive/negative redaction cases,
  untrusted prompt transport, oversized stdin refusal, invalid/oversized diff
  handling, comparison-context cache identity, atomic PR metadata, missing
  fields, and changing-head refusal. `bash scripts/ava-ci-contract` is the
  current local gate; remote CI and reviewer evidence were not refreshed.
  Private index/crosswalk/manifests live in Dawa_Notepad and are not public
  Core inputs. The original archive manifest remains preserved separately.
  Dawa's choice remains required before any integration or publication.

  FROZEN. docs/CANDIDATE_FREEZE_2026-10-04.md + docs/CANDIDATE_FREEZE_2026-10-04.sha256
  record the exact 191-file byte manifest (aggregate digest
  6cfcfb140d6999202d663ffe4b6002a3fedd210ca788baf9b3b7f6b4ed59a3a9) of the
  Codex candidate worktree (codex-build @ 61a2148) at freeze time. That freeze
  also found this section's own ROOT HEAD note stale: live ROOT HEAD is
  5414507, one commit ahead of 61a2148, not diverged.
  Remaining: request Claude's independent read-only review of that exact
  frozen snapshot (verify the aggregate digest first). Compare results with
  any existing handoff evidence by digest; rerun focused tests for every
  accepted fix. Keep the other dirty worktrees untouched and unmerged.
  Dawa's remaining choices: which candidate changes to adopt; which D&D edition
  sources/crossing scope to authorize; whether any provider/model may be tested
  live; and whether to authorize integration or publication.
