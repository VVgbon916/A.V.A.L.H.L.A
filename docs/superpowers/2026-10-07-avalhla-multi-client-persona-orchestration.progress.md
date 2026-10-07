# SDD ledger — plan: docs/superpowers/plans/2026-10-07-avalhla-multi-client-persona-orchestration.md

Pre-flight: the plan's interfaces chain manifest → setup/dialogue/plugin tools → verification; all later tasks consume the canonical manifest from Task 1.

Ruling: use the current non-main sync branch and the writable workspace API instead of the standard `.superpowers` ledger path — the repository resolves to read-only `/var/home` for shell writes, while the current branch is already an authorized Avalhla integration branch and existing dirty work must be preserved.

Task 1: in_progress

Task 1: Ruling: Desktop Commander uses `local_process` rather than one-time OAuth — it is a local executable and has no remote login flow; cost if wrong: a future adapter could misclassify local startup as an authentication failure.

Task 1: complete (tests: `bash tests/test_multi_client_manifest.sh` → MULTI_CLIENT_MANIFEST_TEST_OK)

Task 2: Ruling: the setup tool refuses to synthesize a Desktop Commander command when no executable is supplied — cost if wrong: auto-start remains deferred until the actual local executable is explicitly identified, avoiding a fake or broken command.

Task 2: complete (tests: `bash tests/test_client_setup.sh && scripts/avalhla-cobuilder verify-pack` → CLIENT_SETUP_TEST_OK; PACK VERIFY: PASS)

Task 3: Ruling: paired chat is rendered as a deterministic labeled transcript rather than claiming native multi-agent support in every client — cost if wrong: clients without native speaker orchestration still need a wrapper or prompt adapter to display the contract.

Task 3: complete (tests: `bash tests/test_multi_client_manifest.sh && bash tests/test_client_setup.sh && bash tests/test_dialogue.sh && bash tests/test_cobuilder_projection.sh` → all four PASS)

Task 4: Ruling: plugin discovery is catalogued and non-mutating; unavailable prerequisites such as `dnx`/`.NET` classify a plugin as deferred rather than triggering installation or enablement — cost if wrong: a user must explicitly install and authorize optional integrations later.

Task 4: complete (tests: `bash tests/test_plugin_audit.sh && bash tests/test_multi_client_manifest.sh && bash tests/test_client_setup.sh && bash tests/test_dialogue.sh` → all four PASS)

Task 5: Ruling: Desktop Commander is represented as the existing hyphenated `desktop-commander` key, and the setup tool preserves extra client-owned fields such as `tools`, `type`, and `env` — cost if wrong: a naming mismatch or replacement merge could create duplicate servers or remove client behavior.

Task 5: Ruling: equivalent `/home` and `/var/home` symlink paths are treated as unchanged — cost if wrong: a real executable change could be missed only when both paths resolve to the same file.

Task 5: Ruling: the existing local read-only repository MCP now bounds multi-query results per query instead of failing after discovering more than `max_results`; it still fails closed for payload-size and invalid-limit violations — cost if wrong: callers receive fewer results but retain representative query coverage.

Task 5: Ruling: pre-existing dirty files `scripts/ava-ci-contract`, `scripts/ava-health`, `scripts/ava-resume`, and `docs/HANDOFF.md` were not staged wholesale; additive syntax/inventory fixes remain in the worktree to avoid overwriting user-owned edits.

Task 5: complete (tests: `bash scripts/ava-ci-contract` with fixture write access → 168 pass, 0 fail; all four client plans → unchanged after Dawa Desktop apply; local repo MCP → 10 tests OK)

Final review: self-review (no subagent tool available).

Final: fixed stale TOML dry-run reporting — `plan` now uses the same section-value comparison as `apply`; regression test `test_client_setup.sh` RED→GREEN, full contract 168/168.

Final: fixed Codex format projection — TOML receives only `url` for GDP while JSON clients receive `type` plus `url`; regression test `test_client_setup.sh` RED→GREEN, all four live client plans now report unchanged.
