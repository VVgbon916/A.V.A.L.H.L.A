# Changelog

All notable changes to Avalhla are documented here.

This project currently uses an `Unreleased` section while release/version naming remains intentionally separate from the active development gates.

## [Unreleased] - 2026-09-27

### Added

- `COBUILDER INIT` as the first-contact activation for AI co-building.
- `COBUILDER MODE` as the active co-building state.
- `COBUILDER // DEVILASH` as the adversarial verification method, not an agent identity.
- `scripts/ava-cobuilder init` as a read-only local activation door.
- Canonical CoBuilder activation order in `AGENTS.md`, including real-state, source, cross-check, verification, review, and Dawa human-gate stages.
- Explicit two-lane editor boundary: Dawa_Notepad remains USER ONLY; Avalhla `memory/auto-read/` remains the canonical auto-read lane.
- Static-contract coverage for the canonical CoBuilder activation door.

### Changed

- CoBuilder machine state now records the activation vocabulary and operating method.
- CoBuilder toolbelt, command inventory, source map, and README expose the new activation door and role vocabulary.
- Reviewer output remains evidence only; current repository source remains the authority.
- The Sublime two-folder workspace remains editor visibility only and does not grant runtime or model-ingestion authority.

### Security

- Pinned the workflow's `actions/checkout` dependency to the immutable `v6.1.0` commit `d23441a48e516b6c34aea4fa41551a30e30af803` rather than a mutable version tag.

### Fixed

- None recorded in this changelog entry; executable-mode restoration for `scripts/ava-ci-contract` remains a separate local review change until it is committed and verified.

## Changelog discipline

- Record notable human-facing changes, not a copy of the Git log.
- Keep the newest material first.
- Keep unreleased work under `Unreleased`.
- Do not turn the changelog into a second project map, guide, or source of truth.
