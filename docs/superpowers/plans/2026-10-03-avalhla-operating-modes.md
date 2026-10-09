# Avalhla Operating Modes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make BUILD the default Avalhla workflow while adding SOLO, PARTY, COUNCIL, and discoverable mode routing without weakening existing CoBuilder, DEVILASH, review, safety, provenance, or human-authority contracts.

**Architecture:** Add one thin `ava` router over existing capabilities. Keep authority and verification in existing deterministic boundaries. Introduce explicit mode/party/council contracts before provider adapters; external coding workers use isolated branches/worktrees and return candidate work/evidence only.

**Tech Stack:** zsh/bash-compatible shell scripts, Python 3 for structured contracts where already appropriate, JSON canonical operating law, Git/worktrees, existing shell/Python tests and GitHub `avalhla-static-contract` CI.

**Spec:** `docs/superpowers/specs/2026-10-03-avalhla-operating-modes-design.md`

## Global Constraints

- `ava` and `ava build` are routing-equivalent.
- SOLO disables external AI delegation but not Avalhla safety/review capabilities.
- PARTY members may code; concurrent writers must be isolated.
- COUNCIL converges on one QUEST and never becomes a voting authority.
- Persona, provider, PRESENCE, ASPECT, ROLE, ABILITY, SKILL, and PARTY membership grant no authority.
- Existing evidence-before-mutation, DEVILASH, review, provenance, and Dawa human gates remain intact.
- No repository-wide blind rename; classify canonical names, aliases, executable identifiers, lore, compatibility names, and historical records first.
- Dawa chooses.

## Review Focus

- Unknown/ambiguous mode names must fail safely and show discovery help rather than silently selecting an authority-changing behavior.
- SOLO must mechanically prevent provider delegation while retaining local tests/review/DEVILASH.
- PARTY worker failures or stale branches must not contaminate canonical state or be mistaken for approved work.
- COUNCIL must reject/flag mismatched QUEST identities so evidence from different questions is not synthesized as one result.
- Legacy AwA/AvvA/Avalhla vocabulary must not be blindly rewritten when an occurrence is historical, executable, or compatibility-sensitive.

---

### Task 1: Repository vocabulary and command-surface inventory

**Files:**
- Create: `docs/architecture/AVA_MODE_INVENTORY.md`
- Create: `tests/test_ava_mode_inventory.sh`
- Read/classify: root docs, `docs/`, `scripts/`, `persona/`, `memory/auto-read/`, `config/`, `systemd/`, tests and CI configuration

**Interfaces:**
- Consumes: current repository at implementation branch HEAD.
- Produces: classification table of command entrypoints, concept names, authority-sensitive consumers, historical/compatibility occurrences, and proposed canonical ownership.

- [ ] **Step 1:** Write `tests/test_ava_mode_inventory.sh` asserting the inventory contains classifications for executable, canonical-human, machine-contract, compatibility, lore, and historical occurrences plus known command/authority surfaces.
- [ ] **Step 2:** Run the test and verify it fails because `docs/architecture/AVA_MODE_INVENTORY.md` does not exist.
- [ ] **Step 3:** Generate the inventory from repository evidence; explicitly record legacy `AwA_*` root artifacts instead of renaming them.
- [ ] **Step 4:** Run the inventory test and `git diff --check`; both must pass.
- [ ] **Step 5:** Commit only inventory + test.

### Task 2: Canonical mode and authority contract

**Files:**
- Create: `config/ava/operating-modes.v1.json`
- Modify: `memory/auto-read/00_AI_COBUILD.json`
- Create: `tests/test_operating_modes_contract.py`

**Interfaces:**
- Consumes: vocabulary classifications from Task 1.
- Produces: versioned definitions for BUILD, SOLO, PARTY, COUNCIL; authority invariants; evidence classification; provider-neutral worker capabilities.

- [ ] **Step 1:** Write failing Python contract tests asserting default=`BUILD`, `ava` alias=`build`, SOLO external delegation=false, PARTY coding=true + isolated_writer=true, COUNCIL single_quest=true, and all model/persona/aspect/role capability classes are non-authoritative.
- [ ] **Step 2:** Run the focused test and confirm failure from missing contract.
- [ ] **Step 3:** Add the smallest versioned JSON contract and pointer/summary in `00_AI_COBUILD.json`; do not duplicate full semantics in auto-read.
- [ ] **Step 4:** Run JSON parse, focused contract test, existing CoBuilder/static-contract tests, and `git diff --check`.
- [ ] **Step 5:** Commit contract + tests.

### Task 3: Thin `ava` mode router and discovery UX

**Files:**
- Create: `scripts/ava`
- Create: `tests/test_ava_modes.sh`
- Modify: `COMMANDS.txt` and/or canonical command reference identified by Task 1

**Interfaces:**
- Consumes: `config/ava/operating-modes.v1.json`.
- Produces: `ava`, `ava build`, `ava solo`, `ava party`, `ava council`, `ava modes`, `ava help` routing contract; no provider implementation yet.

- [ ] **Step 1:** Write failing shell tests for no-arg BUILD equivalence, explicit modes, `modes`, help, and unknown-mode safe failure.
- [ ] **Step 2:** Run focused test and verify failure because router is absent.
- [ ] **Step 3:** Implement the smallest router that reads/validates the canonical mode contract and dispatches only implemented/local-safe paths; PARTY/COUNCIL may initially report provider orchestration as not configured rather than inventing adapters.
- [ ] **Step 4:** Run focused tests, ShellCheck where available, existing command tests, and `git diff --check`.
- [ ] **Step 5:** Commit router + discovery docs + tests.

### Task 4: SOLO enforcement boundary

**Files:**
- Create: `scripts/lib_ava_mode.sh` or focused equivalent selected from existing shell-library conventions
- Modify: model/provider dispatch call sites identified by Task 1
- Create: `tests/test_ava_solo.sh`

**Interfaces:**
- Consumes: selected mode from router/contract.
- Produces: deterministic `ava_mode_external_allowed`-style predicate used at provider boundary, not prompt-only instructions.

- [ ] **Step 1:** Write negative tests proving SOLO denies external provider dispatch and positive tests proving local Avalhla capabilities remain callable.
- [ ] **Step 2:** Run tests and confirm the negative path currently fails.
- [ ] **Step 3:** Implement enforcement at the narrow provider/tool dispatch boundary; do not scatter persona checks through callers.
- [ ] **Step 4:** Run SOLO tests plus existing model-input/safety tests and `git diff --check`.
- [ ] **Step 5:** Commit boundary + tests.

### Task 5: PARTY worker/evidence contract and isolated-writer lifecycle

**Files:**
- Create: `config/ava/party-worker.v1.json`
- Create: `scripts/ava-party`
- Create: `tests/test_ava_party.sh`
- Reuse/extend existing action, integrity, provenance, and review libraries identified by Task 1 rather than duplicating them.

**Interfaces:**
- Consumes: QUEST/task id, provider/worker id, base commit, requested role/scope.
- Produces: isolated worker branch/worktree metadata and structured candidate-work envelope containing patch/diff reference, tests, sources where applicable, contradictions, unknowns, limitations, and proposed actions.

- [ ] **Step 1:** Write failing tests for unique worker workspace ownership, dirty/stale base refusal, evidence envelope required fields, and provider identity granting no authority.
- [ ] **Step 2:** Run focused tests and confirm failures.
- [ ] **Step 3:** Implement provider-neutral worker lifecycle first; use native worktree support when available and safe Git fallback otherwise. Do not implement provider-specific Claude/Codex invocation in this task.
- [ ] **Step 4:** Add negative test proving two writers cannot claim the same workspace and stale worker output cannot be treated as current without revalidation.
- [ ] **Step 5:** Run PARTY, integrity, action-boundary, review-gate and regression tests; run `git diff --check`.
- [ ] **Step 6:** Commit lifecycle + contract + tests.

### Task 6: Provider adapters for Codex and Claude

**Files:**
- Create: `config/ava/providers.v1.json`
- Create: `scripts/providers/ava-provider-codex`
- Create: `scripts/providers/ava-provider-claude`
- Create: `tests/test_ava_providers.sh`

**Interfaces:**
- Consumes: PARTY worker request/envelope schema from Task 5.
- Produces: provider-neutral result envelope; provider availability/capability discovery; no provider may bypass PARTY lifecycle.

- [ ] **Step 1:** During implementation, inspect installed/current Codex and Claude CLI/API capabilities and official docs; record exact supported invocation/auth assumptions instead of guessing.
- [ ] **Step 2:** Write adapter contract tests using fakes/fixtures so CI requires no credentials or network.
- [ ] **Step 3:** Implement capability detection and explicit unavailable states; never silently fall back to a different provider.
- [ ] **Step 4:** Implement adapters only for capabilities verified in Step 1, passing all output through the Task 5 envelope validator.
- [ ] **Step 5:** Run provider fixture tests plus PARTY and authority tests; verify secrets/tokens are neither logged nor committed.
- [ ] **Step 6:** Commit adapters + tests + provider contract.

### Task 7: COUNCIL single-QUEST research orchestration

**Files:**
- Create: `config/ava/council.v1.json`
- Create: `scripts/ava-council`
- Create: `tests/test_ava_council.sh`

**Interfaces:**
- Consumes: one QUEST, canonical aspect/lens definitions, optional external researcher adapters.
- Produces: provenance-preserving evidence set with agreements, contradictions, unknowns, and synthesis input; never an authorization vote.

- [ ] **Step 1:** Write failing tests for required QUEST id, mismatched QUEST rejection, aspect outputs classified as evidence, contradiction preservation, and no vote/authority field.
- [ ] **Step 2:** Run tests and confirm failure.
- [ ] **Step 3:** Implement orchestration using canonical aspect definitions discovered in Task 1; do not hard-code new meanings for Lux/Vex/Valhla/Lhlava.
- [ ] **Step 4:** Add optional external researchers through the same provider/evidence boundary as PARTY, but read/research mode only for a COUNCIL run unless a separate PARTY task is spawned.
- [ ] **Step 5:** Run COUNCIL, evidence, provenance and review tests plus `git diff --check`.
- [ ] **Step 6:** Commit council orchestration + tests.

### Task 8: D&D vocabulary canonicalization without destructive rename

**Files:**
- Create or modify canonical vocabulary artifact identified by Task 1
- Create: `docs/DND_SEMANTIC_MAP.md`
- Create: `tests/test_vocabulary_contract.py`
- Modify only occurrences classified safe for migration by Task 1

**Interfaces:**
- Consumes: inventory + operating-mode concepts.
- Produces: one concept registry mapping preferred term, aliases, semantic scope, artifact ownership, and explicit `authority=false` where applicable.

- [ ] **Step 1:** Write tests for unique preferred names, unambiguous aliases, canonical artifact ownership, and authority-negative semantics for metaphorical terms.
- [ ] **Step 2:** Run tests and confirm missing/inconsistent mappings fail.
- [ ] **Step 3:** Add canonical D&D semantic map and minimally migrate safe human-facing occurrences; preserve historical and compatibility-sensitive names with explicit annotations/aliases.
- [ ] **Step 4:** Search for mismatches and run vocabulary tests, existing action vocabulary tests, JSON validation, and `git diff --check`.
- [ ] **Step 5:** Commit semantic map + safe migrations + tests.

### Task 9: Full DEVILASH/regression/review crossing

**Files:**
- Modify: CI/static-contract configuration only if needed to include new tests/contracts
- Create: `tests/test_ava_modes_regression.sh` if a combined harness is not already canonical
- Update canonical human docs/board discovered by Task 1

**Interfaces:**
- Consumes: all prior tasks.
- Produces: one deterministic regression gate and review evidence for the complete operating-mode architecture.

- [ ] **Step 1:** Add combined regression assertions covering BUILD default, SOLO denial, PARTY isolated coding, COUNCIL single QUEST, authority negatives, malformed contracts, stale worker evidence, and vocabulary compatibility.
- [ ] **Step 2:** Run positive and negative suites; any required failure holds the phase.
- [ ] **Step 3:** Run DEVILASH adversarial checks against mode spoofing, prompt claims of authority, provider-output authorization, workspace collision, stale evidence, and historical-name migration.
- [ ] **Step 4:** Run deterministic structured review gate with BUGS / SECURITY / PERF / STYLE / VERDICT and preserve findings as evidence only.
- [ ] **Step 5:** Run repository JSON validation, ShellCheck where applicable, full tests, static contract, and `git diff --check`.
- [ ] **Step 6:** Present final diff/evidence to Dawa. Do not merge/push canonical integration on model authority.

## Self-review result

Coverage: all approved spec invariants map to Tasks 1-9. Provider-specific behavior is deliberately deferred until capability discovery so the plan does not invent Codex/Claude interfaces. The vocabulary migration is separated from command routing to prevent a giant semantic rewrite. PARTY lifecycle precedes provider adapters so external models cannot define their own permissions. COUNCIL reuses evidence/provider boundaries but remains research-only unless it explicitly spawns a PARTY coding task.
