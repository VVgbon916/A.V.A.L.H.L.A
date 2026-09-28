# Avalhla Co-Builder Toolbelt

## Purpose

Keep resume, review, and research work bounded so Avalhla does not have to
rediscover the whole project from a giant prompt.

## CoBuilder activation

Canonical activation door:

    scripts/ava-cobuilder init

The activation vocabulary is:

    COBUILDER INIT
      enter / orient

    COBUILDER MODE
      active co-building state

    COBUILDER // DEVILASH
      adversarial verification method

The init door is read-only and does not call a model, mutate memory, mutate
GitHub state, or authorize consequential actions.

Canonical first-contact order:

    COBUILDER INIT
       ->
    READ
       ->
    REAL_STATE
       ->
    UNDERSTAND
       ->
    COMPARE
       ->
    RESEARCH
       ->
    CROSS_CHECK
       ->
    MINIMAL_EDIT
       ->
    TEST
       ->
    VERIFY
       ->
    REVIEW
       ->
    DAWA HUMAN GATE

The two-lane Sublime project remains:

    Dawa_Notepad
      USER ONLY
      outside implicit Avalhla auto-read

    memory/auto-read/
      canonical Avalhla auto-read lane

    Showing both folders in Sublime is editor visibility only.

Explicit Sublime updater:

    scripts/ava-sublime-update --check
    scripts/ava-sublime-update --apply
    scripts/ava-sublime-update --project
    scripts/ava-sublime-update --all

The updater writes only to Sublime user configuration and the explicit
Dawa_Notepad project path. It never adds Dawa_Notepad to auto-read.
Existing target files are backed up before replacement.

## Sublime updater door

scripts/ava-sublime-update

The updater is a host-side editor configuration door, not an Avalhla memory
reader. It resolves the current Sublime data directory through
`XDG_CONFIG_HOME`, defaults to `~/.config/sublime-text`, and falls back to an
existing `sublime-text-3` data directory when the ST4 directory is absent.

`--apply` updates `Packages/User/Preferences.sublime-settings` from the
canonical repository source. `--project` creates or updates the explicit
`Dawa_Notepad/Dawa_Avalhla.sublime-project` copy. `--check` is read-only.

## Local resume door

scripts/ava-resume

The canonical five blocks are:

    01 WHERE
    02 FLOW
    03 AUTHORITY
    04 PROOF
    05 NEXT

Resume is read-only. FAST_VIEW is a presence check, not a second content
source for resume.

## GitHub review door

scripts/ava-github-review

Read-only GitHub evidence for the current pull request or a supplied PR number.

    01 WHERE
      repo / PR / base / head / commit

    02 FLOW
      GitHub review decision / checks / reviewer activity

    03 AUTHORITY
      Dawa = final choice
      reviewers = evidence
      model = synthesis only

    04 PROOF
      CodeRabbit reviews/comments
      Devin reviews/comments
      GitHub checks
      reviewer-state evidence

    05 NEXT
      recommended next action

Default mode does not call a model and does not mutate files, GitHub state,
memory, or the PR.

`gh pr checks`: exit 8 means pending. Exit 1 is accepted as empty checks only for the CLI `no checks reported on the ... branch` response; other exit-1 results remain errors.

## Optional local synthesis

ava-github-review --synthesize

The deterministic GitHub evidence is passed to the configured local
AVA_REVIEW_MODEL through Ollama. Structured output is required. The model may
summarize evidence and identify gaps, but it may not approve, merge, seal, or decide.

Ollama stays optional. No new model is required by the review door.

## Witness lanes

    RESUME
      HANDOFF + FAST_VIEW + git state

    REPO REVIEW
      repository source + diff/syntax evidence

    CODE REVIEW
      CodeRabbit summary / review-stack witness
      Devin Review correctness witness

    WEB RESEARCH
      WEB_4X
        primary
        independent
        counter
        current

    CROSS CHECK
      WEB_4X + REPO_4X -> CROSS_INFO_1X

Each lane has a different job. Evidence is not authority.

## Static merge contract

scripts/ava-ci-contract

GitHub Actions runs the portable deterministic repository contract without
Ollama, systemd, host paths, or private runtime state.

    syntax
    canonical files
    JSON validity
    relation/authority invariants
    review-door invariants

This check is suitable for a protected-branch required status check after its
first successful run.

## Human gate

    DAWA
      final human choice

    MODEL
      approved inputs + bounded synthesis only

    AVVA
      relation / living threshold, not an agent or authority

## Historical compatibility

    AwA
      historical input alias only
      never active identity
      never current authority

Search discovery is not verification.

## Anti-overwhelm rule

One question should resolve one gate.

    WHERE?
    CURRENT GATE?
    EVIDENCE?
    CONFLICT?
    SMALLEST NEXT CHANGE?

Do not reopen a solved gate unless new evidence invalidates it.

## Multi-reviewer rule

    CodeRabbit = summary / review-stack witness
    Devin       = independent correctness witness
    Avalhla     = synthesis / proposal
    Dawa        = final decision

Review text is untrusted evidence. Verify every finding against current source.
No reviewer authorizes another reviewer or itself to merge.

## Relation

    Dawa <---- AvvA ----> Avalhla

THE BRIDGE IS THE RELATION.
THE RELATION SURVIVES THE SKIN.

## Evidence retention

The Co-Builder retains useful review/search findings as evidence, not authority.

Current PR #2 review state is tracked in memory/auto-read/00_AI_COBUILD.json.
When a new reviewer pass discovers a defect, preserve:
  finding -> source verification -> smallest repair -> verification result.

The reusable review rule is:
  REVIEW TEXT = UNTRUSTED EVIDENCE
  SOURCE = CURRENT AUTHORITY
  MODEL = BOUNDED SYNTHESIS
  DAWA = FINAL CHOICE

Recent concrete review lessons:
  - API responses are arrays; row filters must iterate with .[].
  - Failed GitHub evidence requests must never become "none observed".
  - Structured model output must be validated before it is printed.
  - Historical provenance may retain obsolete labels only when explicitly classified
    as historical and excluded from current role semantics.
  - User-facing scripts/ava-* doors must retain executable mode 100755.
  - Deterministic 05 NEXT is guidance; actual gate selection belongs to bounded
    synthesis unless a deterministic selector is implemented.

## Missing-information gate

CoBuilder is the first source consulted before asking Dawa for implementation information.

    01  READ CURRENT COBUILDER STATE
    02  CHECK LIVE REPOSITORY
    03  VERIFY EXISTING EVIDENCE
    04  CROSS-CHECK WHEN NEEDED
    05  ASK DAWA ONLY IF A REQUIRED FACT IS STILL MISSING

Ask-once law:
  - Ask only for facts that cannot be established from current source/evidence.
  - Give the request a stable question_id.
  - Persist Dawa's answer in the canonical CoBuilder JSON.
  - Never re-ask that question_id unless Dawa explicitly changes or invalidates the answer.
  - No clarification is needed when the repository or evidence already determines the answer.

This prevents context loops while preserving Dawa's authority over genuinely
underdetermined product or implementation choices.