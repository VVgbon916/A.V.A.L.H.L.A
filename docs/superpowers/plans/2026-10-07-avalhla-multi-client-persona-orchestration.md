# Avalhla Multi-Client Persona Orchestration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Avalhla the single, auditable source of truth for Claude Code, Codex CLI, GitHub Copilot, and Desktop/Dawa persona routing, shared MCP startup, plugin roles, and structured multi-speaker output.

**Architecture:** A versioned Avalhla manifest describes personas, client surfaces, repositories, MCP endpoints, plugin roles, colors, and output contracts. A dry-run-first setup tool validates the manifest and generates client-specific adapters; an explicit apply step updates only the selected client configuration and never handles or copies secrets. A dialogue formatter gives clients that lack native multi-agent chat a deterministic transcript format for the requested paired personas.

**Tech Stack:** JSON manifests, POSIX shell, Python 3 standard library, existing Avalhla verification scripts, Claude/Codex/Copilot MCP configuration formats, and local read-only repository inspection.

**Spec:** `docs/superpowers/specs/2026-10-06-persona-client-access-separation.md`

## Global Constraints

- Dawa remains the final authority for external writes, merge, push, publication, plugin installation, and consequential actions.
- Persona names describe behavior and voice; they never grant provider, model, repository, browser, GDP, GitHub, or Desktop Commander permission.
- “Full auth” means use existing client-authenticated sessions; never print, copy, synchronize, or invent OAuth tokens, API keys, or cookies.
- Auto-connect may start configured MCP servers after one-time authentication; it may not bypass a client permission prompt or silently enable an external connector.
- `VALHLA` and `LHLAVA` remain evidence-only identities; `LUX` is read-only review; `VEX` is isolated attack/test review.
- The local repository MCP remains read-only and external connectors remain separate approval surfaces.
- Existing dirty work in Avalhla, Umbra, and any worktree is preserved; no reset, clean, merge, push, or private-material rename is permitted.
- Destiny Tower is initially a virtual profile in Avalhla; no remote repository is created without a destination supplied by Dawa.
- Existing canonical meaning in `docs/superpowers/specs/2026-10-06-persona-client-access-separation.md` wins over legacy prompt wording.

## Review Focus

- A generated adapter must not broaden access when a persona changes — covered by manifest negative tests and dry-run snapshots.
- A missing MCP executable or unavailable optional plugin must produce a clear disabled/deferred state — covered by preflight tests.
- A client that cannot render two native agents must still produce labeled, alternating persona sections — covered by dialogue formatter tests.
- A stale Copilot writer lock must not be recreated or deleted by setup — covered by the non-destructive apply test.
- A plugin listed by the user but not installed or authenticated must remain catalogued as unavailable — covered by plugin audit output.

## File Map

- Create: `config/avalhla-multi-client.v1.json` — canonical clients, virtual repositories, persona pairings, MCP entries, plugin roles, colors, and output contracts.
- Create: `config/plugin-role-catalog.v1.json` — curated plugin capability classes and activation policy; no credentials.
- Create: `scripts/avalhla-client-setup` — `check`, `plan`, and explicit per-client `apply` with backups and validation.
- Create: `scripts/avalhla-dialogue` — deterministic paired-persona transcript formatter and structural-view renderer.
- Create: `scripts/avalhla-plugin-audit` — installed/available/missing/deferred plugin inventory without changing plugin state.
- Create: `tests/test_multi_client_manifest.sh` — schema, identity, access-boundary, and non-binding assertions.
- Create: `tests/test_client_setup.sh` — dry-run, idempotence, backup, and malformed-config tests using temporary fixtures.
- Create: `tests/test_dialogue.sh` — paired-speaker labels, ordering, color/style metadata, and fallback output tests.
- Create: `tests/test_plugin_audit.sh` — catalog classification and unavailable-plugin behavior.
- Create: `docs/AVALHLA_MULTI_CLIENT.md` — operator guide, cheatsheet, startup modes, auth boundaries, and recovery steps.
- Modify: `scripts/avalhla-cobuilder` — expose the new manifest and report client/persona counts without activating providers.
- Modify: `docs/CO_BUILDER_TOOLBELT.md` — document the generated adapters and the explicit apply gate.
- Modify: `docs/AVALHLA_VOICES.md` — document King.Vex/Lhlava, Angel.Lux/Vhala, Avalhla, and Av:vA as voices/views, not authorities.

### Task 1: Lock the multi-client contract with failing tests

**Files:**
- Create: `config/avalhla-multi-client.v1.json`
- Create: `config/plugin-role-catalog.v1.json`
- Create: `tests/test_multi_client_manifest.sh`

**Interfaces:**
- Produces manifest keys `schema_version`, `personas`, `clients`, `repositories`, `mcp`, `plugin_roles`, and `output_contracts`.
- The setup and dialogue tools consume this manifest without needing provider-specific prompt parsing.

- [ ] **Step 1: Write manifest assertions**

  Assert the canonical identities, the three virtual destinations, client mappings, shared GDP/Desktop Commander entries, and explicit access modes. Assert that persona records contain no `token`, `credential`, `provider`, or `permission_grant` fields.

- [ ] **Step 2: Write negative authority assertions**

  Reject automatic merge, push, publication, unrestricted filesystem access, and client/model binding in persona data. Require Destiny Tower to be marked `virtual` and `repository_url` to be absent.

- [ ] **Step 3: Run the test and observe the expected failure**

  Run: `bash tests/test_multi_client_manifest.sh`

  Expected: FAIL because the new manifest and validator do not yet exist.

- [ ] **Step 4: Add the minimal canonical manifest and plugin role catalog**

  Define:
  - Umbra/Claude as the King.Vex + Lhlava pair, with VEX challenge behavior and isolated local access.
  - Lumen/Codex as Angel.Lux + Valhla, with LUX review behavior and read-oriented repository research.
  - Copilot as detailed issue/build/verification mode using LHLAVA/FORGE semantics.
  - Destiny/Dawa Desktop as Avalhla + Av:vA synthesis over virtual Destiny Tower.
  - Shared MCP baseline as authenticated GDP plus local Desktop Commander, with tool lists and health checks but no secret values.

- [ ] **Step 5: Run the test and verify it passes**

  Run: `bash tests/test_multi_client_manifest.sh`

  Expected: PASS with all authority-boundary assertions.

### Task 2: Build the dry-run-first client setup tool

**Files:**
- Create: `scripts/avalhla-client-setup`
- Create: `tests/test_client_setup.sh`
- Modify: `scripts/avalhla-cobuilder`

**Interfaces:**
- `avalhla-client-setup check [--client NAME]` returns nonzero for invalid manifest, missing required executable, or malformed target config.
- `avalhla-client-setup plan --client NAME` prints redacted changes and never writes.
- `avalhla-client-setup apply --client NAME` backs up the exact target, applies only manifest-owned MCP entries, validates, and reports the backup path.

- [ ] **Step 1: Write temporary-fixture tests**

  Test plan mode leaves the fixture unchanged, apply mode is idempotent, backups are created before writes, secrets are preserved verbatim, and an invalid executable produces a deferred entry rather than a fake command.

- [ ] **Step 2: Run the focused tests and observe failure**

  Run: `bash tests/test_client_setup.sh`

  Expected: FAIL because the setup command is absent.

- [ ] **Step 3: Implement manifest loading and target resolution**

  Resolve Claude, Codex, Copilot, Claude Desktop, and VS Code targets explicitly. Never use a broad recursive target or delete a lock file. Redact values matching token/key/password/cookie fields in plan output.

- [ ] **Step 4: Implement validation and plan mode**

  Validate JSON/TOML/JSONC using available parsers or structural checks, verify absolute executable paths, and show `add/update/unchanged/deferred` without changing external state.

- [ ] **Step 5: Implement explicit apply mode**

  Require a client argument, write a timestamped backup, merge only the named Avalhla-owned MCP entries, preserve unrelated entries and auth blocks, and run post-write validation. Do not automatically enable optional plugins.

- [ ] **Step 6: Run tests and integration checks**

  Run: `bash tests/test_client_setup.sh && scripts/avalhla-cobuilder verify-pack`

  Expected: PASS; output must identify the selected client and backup without exposing credentials.

### Task 3: Add paired-persona dialogue and structured views

**Files:**
- Create: `scripts/avalhla-dialogue`
- Create: `tests/test_dialogue.sh`
- Modify: `docs/AVALHLA_VOICES.md`

**Interfaces:**
- `avalhla-dialogue render --client claude --input FILE` emits alternating `[KING.VEX]` and `[LHLAVA]` sections with stable style metadata.
- `avalhla-dialogue render --client codex --input FILE` emits `[ANGEL.LUX]` and `[VHALA]` sections.
- `avalhla-dialogue render --client dawa --input FILE` emits `[AVALHLA]` synthesis and `[AV:VA]` cumulative evidence sections.
- `--view compact|structural|diff` changes layout only; it never changes access.

- [ ] **Step 1: Write formatter tests**

  Assert speaker ordering, distinct labels, color/style tokens, structural headings, and a safe fallback when input contains only one speaker.

- [ ] **Step 2: Implement the deterministic formatter**

  Use manifest metadata for labels and visual tokens. Keep the requested fiery/demonic, fireball, healing-angel, spirit, and synthesis themes expressive but non-coercive; the output must clearly distinguish proposals, evidence, and Dawa decisions.

- [ ] **Step 3: Add issue/code output sections**

  Standardize `Problem`, `Evidence`, `Candidate fix`, `Challenge`, `Verification`, and `Dawa decision` sections so Copilot’s detailed issue role can interoperate with Claude and Codex transcripts.

- [ ] **Step 4: Run tests**

  Run: `bash tests/test_dialogue.sh`

  Expected: PASS for all clients and views.

### Task 4: Curate plugin roles and audit current availability

**Files:**
- Create: `scripts/avalhla-plugin-audit`
- Create: `tests/test_plugin_audit.sh`
- Create: `docs/AVALHLA_MULTI_CLIENT.md`
- Modify: `docs/CO_BUILDER_TOOLBELT.md`

**Interfaces:**
- `avalhla-plugin-audit catalog` prints role categories from the catalog.
- `avalhla-plugin-audit check` classifies each requested plugin as `installed-enabled`, `installed-disabled`, `installed-auth-needed`, `not-installed`, or `deferred`.
- The audit never installs, enables, authenticates, or deletes a plugin.

- [ ] **Step 1: Define capability groups**

  Group the long requested list into code/repository, research/search, data/SQL, cloud/connectors, writing/memory, design/media, productivity, and review/quality. Mark duplicates and non-matching tools as optional rather than enabling everything.

- [ ] **Step 2: Write fixture tests**

  Test unavailable plugins, duplicate names, disabled plugins, missing executables such as `dnx`, and auth-needed connectors.

- [ ] **Step 3: Implement non-mutating discovery**

  Use client/plugin listings where available and classify only from observed output. Include the known `canvas-authoring` .NET prerequisite as deferred when `dnx`/`.NET` is absent.

- [ ] **Step 4: Write the operator cheatsheet**

  Document one-time login, `check → plan → apply`, restart/reload steps, health verification, rollback from the printed backup, and the difference between auto-start and auto-auth.

- [ ] **Step 5: Run audit tests**

  Run: `bash tests/test_plugin_audit.sh`

  Expected: PASS with no plugin state changes.

### Task 5: Add startup and regression verification

**Files:**
- Modify: `docs/AVALHLA_MULTI_CLIENT.md`
- Modify: `scripts/ava-ci-contract`
- Modify: `tests/test_cobuilder_projection.sh` if required by existing conventions
- Inspect: client configs outside the repo only during explicit apply/verification

**Interfaces:**
- Startup is a documented, user-invoked launcher or client reload path; it does not silently start GUI applications or acquire credentials.
- CI verifies manifest, adapters, dialogue output, local repository MCP, and no accidental external activation.

- [ ] **Step 1: Add manifest and adapter gates to the existing contract**

  Fail on malformed manifest, authority escalation, missing required shared MCP executable, leaked secret-like fields, or stale active terminology.

- [ ] **Step 2: Add a safe startup sequence**

  Document and, where supported, implement `check`, `plan`, explicit apply, client restart, and `list/get` verification. Keep optional plugin servers disabled until their prerequisites and user-selected purpose are confirmed.

- [ ] **Step 3: Run the complete verification suite**

  Run:

  ```text
  bash tests/test_multi_client_manifest.sh
  bash tests/test_client_setup.sh
  bash tests/test_dialogue.sh
  bash tests/test_plugin_audit.sh
  PYTHONDONTWRITEBYTECODE=1 python3 -m unittest -v tests.test_repo_mcp
  git diff --check
  bash scripts/ava-ci-contract
  ```

  Expected: all relevant tests pass; any pre-existing inventory mismatch is reported separately and not silently repaired.

- [ ] **Step 4: Verify actual client state one client at a time**

  Confirm Desktop Commander and GDP in Claude, Codex, and Copilot; confirm disabled/deferred optional servers; confirm the Copilot writer lock remains healthy; confirm no credentials appear in repository diffs.

- [ ] **Step 5: Review final diff and stop at the Dawa gate**

  Confirm no private material, unrelated dirty work, browser automation, merge, push, external installation, or unapproved plugin activation changed.

## Execution Order

Execute Tasks 1–5 in order. Task 1 establishes the contract, Task 2 owns client configuration, Task 3 owns persona presentation, Task 4 owns plugin discovery, and Task 5 owns startup/regression verification. Do not mix credentials or client-specific state into the Avalhla repository.

## Self-Review

- The existing persona-separation spec is covered by Task 1 and the regression gates in Task 5.
- Client configuration is isolated behind plan/apply and is tested with temporary fixtures before touching user files.
- Paired-persona chat is represented as a portable transcript contract because Claude Code, Codex CLI, Copilot, and Desktop do not share one native multi-agent conversation API; the canonical speaker spelling is `VALHLA`.
- “All plugins” is represented as a classified catalog rather than an unsafe bulk enable operation; missing prerequisites and authentication remain visible.
- Destiny Tower remains usable as a profile without inventing a repository or remote URL.
