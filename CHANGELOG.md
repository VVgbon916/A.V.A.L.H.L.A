# Changelog

All notable changes to Avalhla are documented here.

This project currently uses an `Unreleased` section while release/version naming remains intentionally separate from the active development gates.

## [Unreleased] - 2026-10-06

### Fixed

- Static contract now checks executable Python scripts with Python syntax
  compilation instead of passing them to `bash -n`.
- `Devil3Way` / `Avalhla_Devil3Way all` now restarts all three lanes, so
  one command always leaves exactly three fresh Claude, Codex and Copilot windows.
- Persona lanes upgraded: six distinct anchored voices with color markers
  (🟥 KING.VEX demon/left-brain, 🟧 LHLAVA, 🟨 ANGEL.LUX, 🟦 VALHLA, 🟪 AVALHLA,
  🌈 AV:VA); Vex/Lux/AvvA open ready with the live persona injected and a boot
  prompt (`--quiet` skips it); `<door> rollback` restores the anchor with
  history; Copilot moved to its own local Destiny-Tower repo as AV:VA solo.
- Profile sync now writes the paired-speaker persona contract inside the
  managed AGENTS.md block; Claude (via @AGENTS.md) and Codex never opened the
  referenced AVALHLA_PERSONA_PROFILE.md, so Vex and Lux started persona-less.
- Launcher restart now escalates to SIGKILL when a client ignores SIGTERM,
  no longer loses a stop request that arrives while a client is starting,
  replaces a lane whose client already exited, and keeps the last 5
  terminal logs per lane.
- Added `.github/copilot-instructions.md` so Copilot (Avv) loads the
  Destiny-Tower AV:VA + AVALHLA lane; fixed stale Copilot/Umbra routing row.
- Fixed Vex/Lux/Avv startup: use Konsole's supported `--separate` option,
  acknowledge a running client before reporting launch, and retain startup
  failures. Restart now validates the owned session PID/start time/token,
  excluding desktop servers, unrelated clients, and zombies. The child fresh
  helper now resolves its manifest independently of the selected repository.
- Repaired fresh-terminal `PATH` setup so local Claude/Copilot binaries and
  the bundled Node executable resolve consistently after reboot; added a
  sourced-shell regression check.
- Added `scripts/avalhla-launch` for separate Konsole sessions with explicit
  Claude, Codex, and Copilot lane/persona routing and duplicate-process skips.
- Added `scripts/Avalhla_Devil3Way` as a sourceable board/launch door with
  `all`, `claude-codex`, and read-only `research` modes; research refreshes
  repository, client-MCP, live-client, and plugin-catalogue evidence without
  granting access or enabling connectors.
- Kept launched Konsole sessions open at an interactive shell after a client
  exits, preserving logs and making recovery commands available.
- Added the Destiny-Tower_AvvA-Avalhla interface contract, five-lane resume
  map, and separate Vex/Lux/Avv restart doors with selected-client-only
  shutdown.
- Corrected Copilot routing to virtual `Destiny_Tower` with `AV:VA + AVALHLA`;
  Umbra now carries only a routing notice for the former Copilot mapping.

### Added

- `COBUILDER INIT` as the first-contact activation for AI co-building.
- `COBUILDER MODE` as the active co-building state.
- `COBUILDER // DEVILASH` as the adversarial verification method, not an agent identity.
- `scripts/ava-cobuilder init` as a read-only local activation door.
- `scripts/ava-sublime-update` as an explicit host-side updater for Sublime user settings and the Dawa_Notepad project.
- Tracked `Dawa_Notepad/` as the syncable Dawa user lane, separate from Avalhla `memory/auto-read/`.
- Canonical CoBuilder activation order in `AGENTS.md`, including real-state, source, cross-check, verification, review, and Dawa human-gate stages.
- Explicit two-lane editor boundary: Dawa_Notepad remains USER ONLY; Avalhla `memory/auto-read/` remains the canonical auto-read lane.
- Static-contract coverage for the canonical CoBuilder activation door.
- `docs/CANDIDATE_FREEZE_2026-10-04.md` and `docs/CANDIDATE_FREEZE_2026-10-04.sha256`: a byte-exact freeze (191-file manifest, aggregate digest) of the Codex `codex-build` candidate worktree, requested by `docs/HANDOFF.md` `05 NEXT` ahead of Claude's independent review. The freeze also found and corrected a stale ROOT `HEAD` note in `docs/HANDOFF.md`.
- `docs/REPO_OVERLOOK_2026-10-06.md`, the canonical current-state inventory and missing-work classification.
- `scripts/avalhla-repo-mcp.py` and `tests/test_repo_mcp.py`, a dependency-free local read-only repository MCP with protocol and security coverage.

### Changed

- Persona lane rules now default to compact replies: first speaker on top, second at the bottom, 2-3 lines each, important facts only; one shared board (✓ ✗ ⚠ tree) only when a problem, diff or decision needs it. Synced to Umbra, Lumen and Destiny via `avalhla-profile-sync`; Avalhla's response view uses the same board rule.
- Valhla and Lhlava are defined as distinct, non-authoritative consultation lanes; native skills and engineering doors are explicitly on demand, with no provider activation implied.
- Added `docs/SKILL_SYSTEM.md` as the public routing contract; provider preferences remain deferred pending tests and Dawa's choice.
- Added the Devil3Way coordination preset as documentation-only lane guidance; it does not change authority or provider activation.
- Added MCP read-access documentation and a separate boundary from GDP remote execution and external connector writes.
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
- Kept `ava-doc` and `ava-diff` task instructions in the Ollama system field and untrusted source/diff content in the user field.
- Made oversized stdin fail closed, tightened secret redaction (including non-Bearer Authorization headers) while preserving neighboring data, and captured PR metadata atomically before checking for head changes.
- Made `ava-diff` reject invalid comparison revisions and key cached reviews by source bytes, base/head commits, model, and system-policy digest.
- Added hermetic positive and negative regressions for prompt transport, redaction, oversized input, and PR evidence capture.

### Fixed

- Restored `scripts/ava-ci-contract` to executable mode `100755`.
- Added explicit backup-before-replace behavior to the Sublime updater.
- Added static enforcement for canonical executable-door mode `100755` and JSON validation for the tracked Sublime sources.
- Added a Git-ignored `Dawa_Notepad/private/` escape hatch for local-only material.
- Corrected duplicate section numbering in `docs/DEVELOPMENT.md`.
- Corrected the ASCII-only relation signatures in the chat, code, and review Modelfiles.
- Repaired `scripts/avalhla-cobuilder verify-pack` after the registry moved from `historical_voices` to `consultation_lanes`.

## Changelog discipline

- Record notable human-facing changes, not a copy of the Git log.
- Keep the newest material first.
- Keep unreleased work under `Unreleased`.
- Do not turn the changelog into a second project map, guide, or source of truth.
