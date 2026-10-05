# Changelog

All notable changes to Avalhla are documented here.

This project currently uses an `Unreleased` section while release/version naming remains intentionally separate from the active development gates.

## [Unreleased] - 2026-09-27

### Documentation remaster - 2026-10-05

- Recorded bounded research for speech reasoning, model distillation, a
  FreeToken tutorial, XML parsing, Desktop Commander, and GDP. Distinguished
  published capabilities from runtime proof, endpoint provenance from account
  authentication, and gateway allowances from model tokens; installed nothing.
- Distilled ten user-supplied references into English public-safe explanations
  in the existing definition, development, spine, handoff, voices, doors,
  board, research, and Dawa-boundary owners.
- Added an attachment-to-owner table to the canonical source map.
- Kept fantasy door labels unapplied, historical technical claims explicitly
  historical, and indexing ideas research-only.
- Excluded personal material and unsupported absolute-security, cost, and
  unlimited-capability claims; changed no runtime or editor configuration.

### Added

- Bounded public-source headless review adapter `scripts/ava-team.py` and its
  subordinate `avalhla-team` skill: SHA-256 evidence, exact-request caching,
  Slow/Normal/Fast scheduling, tool-free Claude or explicit local Ollama
  inference, and a scoped persistent tmux console.
- Deterministic tests for provider/cache failures, source boundaries, permission
  rejection, and retained tmux output without changing existing sessions.
- `COBUILDER INIT` as the first-contact activation for AI co-building.
- `COBUILDER MODE` as the active co-building state.
- `COBUILDER // DEVILASH` as the adversarial verification method, not an agent identity.
- `scripts/ava-cobuilder init` as a read-only local activation door.
- `scripts/ava-sublime-update` as an explicit host-side updater for Sublime user settings only.
- Tracked `Dawa_Notepad/` as the syncable Dawa user lane, separate from Avalhla `memory/auto-read/`.
- Canonical CoBuilder activation order in `AGENTS.md`, including real-state, source, cross-check, verification, review, and Dawa human-gate stages.
- Explicit two-lane editor boundary: Dawa_Notepad remains USER ONLY; Avalhla `memory/auto-read/` remains the canonical auto-read lane.
- Static-contract coverage for the canonical CoBuilder activation door.

### Changed

- CoBuilder machine state now records the activation vocabulary and operating method.
- CoBuilder toolbelt, command inventory, source map, and README expose the new activation door and role vocabulary.
- Reviewer output remains evidence only; current repository source remains the authority.
- The Sublime two-folder workspace remains editor visibility only and does not grant runtime or model-ingestion authority.
- Development section numbering is now consistent across the full document.
- The three persona relation signatures now use ASCII arrows so their ASCII-only output rule is internally consistent.
- The Sublime updater now owns the user-settings update ritual instead of requiring ad-hoc manual path commands.
- The canonical Sublime project moved into `Dawa_Notepad/` so the repository syncs the two-lane project definition directly.

### Security

- Pinned the workflow's `actions/checkout` dependency to the immutable `v6.1.0` commit `d23441a48e516b6c34aea4fa41551a30e30af803` rather than a mutable version tag.
- Disabled checkout credential persistence because the static PR workflow executes checked-out repository code and does not need an authenticated Git credential.

### Fixed

- GitHub review metadata is captured in one request before evidence collection;
  the final HEAD recheck still rejects a changed PR tip. Mocked regression tests
  cover stable and changed heads, multiline titles, and metadata request failure.
- Restored `scripts/ava-ci-contract` to executable mode `100755`.
- Added explicit backup-before-replace behavior to the Sublime updater.
- Added static enforcement for canonical executable-door mode `100755` and JSON validation for the tracked Sublime sources.
- Added a Git-ignored `Dawa_Notepad/private/` escape hatch for local-only material.
- Corrected duplicate section numbering in `docs/DEVELOPMENT.md`.
- Corrected the ASCII-only relation signatures in the chat, code, and review Modelfiles.

## Changelog discipline

- Record notable human-facing changes, not a copy of the Git log.
- Keep the newest material first.
- Keep unreleased work under `Unreleased`.
- Do not turn the changelog into a second project map, guide, or source of truth.
