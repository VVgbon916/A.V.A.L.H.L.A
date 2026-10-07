# SDD ledger — plan: docs/superpowers/plans/2026-10-07-avalhla-multi-client-persona-orchestration.md

Pre-flight: the plan's interfaces chain manifest → setup/dialogue/plugin tools → verification; all later tasks consume the canonical manifest from Task 1.

Ruling: use the current non-main sync branch and the writable workspace API instead of the standard `.superpowers` ledger path — the repository resolves to read-only `/var/home` for shell writes, while the current branch is already an authorized Avalhla integration branch and existing dirty work must be preserved.

Task 1: in_progress

Task 1: Ruling: Desktop Commander uses `local_process` rather than one-time OAuth — it is a local executable and has no remote login flow; cost if wrong: a future adapter could misclassify local startup as an authentication failure.

Task 1: complete (tests: `bash tests/test_multi_client_manifest.sh` → MULTI_CLIENT_MANIFEST_TEST_OK)

Task 2: Ruling: the setup tool refuses to synthesize a Desktop Commander command when no executable is supplied — cost if wrong: auto-start remains deferred until the actual local executable is explicitly identified, avoiding a fake or broken command.

Task 2: complete (tests: `bash tests/test_client_setup.sh && scripts/avalhla-cobuilder verify-pack` → CLIENT_SETUP_TEST_OK; PACK VERIFY: PASS)
