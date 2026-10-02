# Avalhla Agent Deployment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deploy the Master role topology as project-scoped Claude Code and Codex agents with deterministic validation, bounded permissions, and compatibility aliases.

**Architecture:** A machine-readable agent registry defines current roles, engine ownership, evidence lanes, and legacy aliases. Claude owns STRIKE and its eight read-only search lanes; Codex owns TRACE, FORGE, MIRROR, VALHLA, and LUX. A Bash validator and Python tests enforce the deployment contract, while existing WITNESS/VEX/ECHO entry points remain compatibility-only until the later naming migration.

**Tech Stack:** Bash, Python 3 unittest, JSON, TOML, Claude Code project agents, Codex project agents, MCP configuration.

**Spec:** `docs/superpowers/specs/2026-10-02-avalhla-master-forensic-architecture-design.md`

## Global Constraints

- `MASTER = METHOD`; no SHA, branch, latest PR, next command, or resolved defect belongs in the Master or agent registry.
- `LAW != LIVE != HISTORY`; agent prompts must not invent current repository state.
- `MODEL SEES != MODEL DECIDES`; agent findings are evidence, never authorization.
- STRIKE is Claude-owned adversarial synthesis through HELLGATE.
- Claude STRIKE may deploy up to eight orthogonal read-only search workers.
- Codex owns TRACE, FORGE, MIRROR, VALHLA, and LUX.
- Only FORGE and MIRROR may receive workspace-write capability; all other canonical agents are read-only.
- Phase 10 remains Dawa's integration gate. Dawa chooses.
- No credential, OAuth, secret, persistent system-security, merge, or release change is part of this plan.
- Preserve unrelated dirty work; implementation stays in the isolated worktree.

## Review Focus

- Parent permission overrides must not silently broaden a supposedly read-only agent into a production writer.
- Legacy WITNESS/VEX/ECHO aliases must not remain authoritative canonical roles.
- STRIKE must be able to spawn eight distinct lanes without allowing lane workers to recursively multiply.
- Agent discovery must match the installed Claude/Codex versions rather than stale registration syntax.
- MCP/documentation access must add evidence capability without adding credentials or write authority.

---### Task 1: Canonical agent deployment contract

**Files:**
- Create: `config/agents/avalhla-agents.v1.json`
- Create: `scripts/ava-agent-check`
- Create: `tests/test_agent_deployment.py`

**Interfaces:**
- Consumes: `docs/COBUILDER_MASTER.md` role and evidence-lane definitions.
- Produces: registry fields `canonical_roles`, `strike_lanes`, `legacy_aliases`, and executable `scripts/ava-agent-check [--live]`.

- [ ] **Step 1: Write failing registry tests**

Add unittest cases asserting canonical roles `TRACE`, `STRIKE`, `FORGE`, `MIRROR`, `VALHLA`, `LUX`; exactly eight STRIKE lanes; engine ownership; read/write class; `Dawa chooses.`; and absence of volatile-state keys.

- [ ] **Step 2: Run the test and prove RED**

Run: `python3 tests/test_agent_deployment.py -v`
Expected: FAIL because the registry and validator do not exist.

- [ ] **Step 3: Create the minimal registry and validator**

The registry records method only. `scripts/ava-agent-check` parses the registry, checks expected project agent files and static permission markers, and exits non-zero on drift. `--live` additionally reports installed Claude/Codex versions and MCP inventory without making model calls.

- [ ] **Step 4: Prove GREEN**

Run: `python3 tests/test_agent_deployment.py -v && scripts/ava-agent-check`
Expected: PASS for registry-only assertions; deployment-file assertions may remain intentionally pending until Tasks 2-3.

- [ ] **Step 5: Commit**

Commit only the registry, validator, and Task 1 tests with a contract-focused message.
### Task 2: Claude STRIKE deployment

**Files:**
- Create: `.claude/settings.json`
- Create: `.claude/agents/strike.md`
- Create: `.claude/agents/strike-source.md`
- Create: `.claude/agents/strike-history.md`
- Create: `.claude/agents/strike-runtime.md`
- Create: `.claude/agents/strike-primary.md`
- Create: `.claude/agents/strike-independent.md`
- Create: `.claude/agents/strike-counter.md`
- Create: `.claude/agents/vex.md`
- Create: `.claude/agents/strike-review.md`
- Create: `.claude/agents/lhlava.md`
- Modify: `tests/test_agent_deployment.py`

**Interfaces:**
- Consumes: Task 1 registry `strike_lanes` and Claude Code 2.1.287 project-agent format.
- Produces: `STRIKE -> eight lanes`, with VEX as the adversarial lane and LHLAVA as an optional forward-pressure search mode.

- [ ] **Step 1: Add failing Claude deployment tests**

Assert project scope, unique names, STRIKE has `Agent`, lane workers do not, no Claude agent exposes Write/Edit, eight lane identities match the registry, spawn depth is `2`, and concurrent subagent ceiling is `9`.

- [ ] **Step 2: Prove RED**

Run: `python3 tests/test_agent_deployment.py -v`
Expected: FAIL on missing `.claude/` deployment.

- [ ] **Step 3: Implement the Claude project agents**

Use YAML frontmatter with explicit tools and read-only permission intent. STRIKE may delegate; its eight lane workers cannot recursively delegate. `strike-runtime` may use Bash only for observation commands and must never mutate files. LHLAVA remains a voice/search mode, not an authority role.

- [ ] **Step 4: Prove GREEN and validate with Claude tooling**

Run: `python3 tests/test_agent_deployment.py -v && scripts/ava-agent-check`
Then run a non-mutating Claude configuration/agent discovery check supported by the installed CLI; record inability to smoke-run a model as evidence rather than fabricating success.

- [ ] **Step 5: Commit**

Commit only Claude deployment files and their tests.
### Task 3: Codex canonical agent deployment

**Files:**
- Modify: `.codex/config.toml`
- Create: `.codex/agents/trace.toml`
- Keep/modify: `.codex/agents/forge.toml`
- Create: `.codex/agents/mirror.toml`
- Create: `.codex/agents/valhla.toml`
- Keep/modify: `.codex/agents/lux.toml`
- Modify: `.codex/agents/witness.toml`
- Modify: `.codex/agents/vex.toml`
- Modify: `.codex/agents/echo.toml`
- Modify: `tests/test_agent_deployment.py`

**Interfaces:**
- Consumes: Task 1 registry and installed Codex 0.159.3 standalone `.codex/agents/*.toml` discovery.
- Produces: canonical Codex TRACE/FORGE/MIRROR/VALHLA/LUX agents plus explicit compatibility aliases for WITNESS/VEX/ECHO.

- [ ] **Step 1: Add failing Codex deployment tests**

Assert TRACE/VALHLA/LUX are read-only, FORGE/MIRROR are workspace-write, stale `config_file` registrations are absent, compatibility files identify themselves as aliases, and `Dawa decides.` is absent from active agent prompts.

- [ ] **Step 2: Prove RED**

Run: `python3 tests/test_agent_deployment.py -v`
Expected: FAIL against the current WITNESS/VEX/ECHO deployment.

- [ ] **Step 3: Implement current Codex agent files**

Preserve global `approval_policy = "on-request"` and workspace sandbox defaults. Do not add MCP credentials. Keep `firecrawl` and `openaiDeveloperDocs` as existing evidence sources; canonical role prompts classify external output as evidence rather than authority.

- [ ] **Step 4: Prove GREEN and inspect live discovery**

Run: `python3 tests/test_agent_deployment.py -v && scripts/ava-agent-check --live`
Then use installed Codex CLI help/status commands to confirm agent discovery without executing a production mutation.

- [ ] **Step 5: Commit**

Commit only Codex deployment files and their tests.
### Task 4: Compatibility, CI, and operator documentation

**Files:**
- Modify: `scripts/ava-ci-contract`
- Modify: `AGENTS.md`
- Modify: `docs/DOOR_ACTIVATION.md`
- Modify: `docs/8X_DOORS.md`
- Modify: `references/DOORBOOK.md`
- Modify: `config/avalhla-naming.v1.json`
- Modify: `tests/test_agent_deployment.py`

**Interfaces:**
- Consumes: deployed Claude/Codex agents and the registry.
- Produces: CI enforcement and human-facing current/compatibility distinction without performing the later full lore migration.

- [ ] **Step 1: Add failing integration tests**

Assert the static contract invokes `scripts/ava-agent-check`; active docs point to TRACE/STRIKE/FORGE/MIRROR/VALHLA/LUX; legacy WITNESS/VEX/ECHO references are explicitly historical/compatibility where retained; and active choice language is `Dawa chooses.`

- [ ] **Step 2: Prove RED**

Run: `python3 tests/test_agent_deployment.py -v && scripts/ava-ci-contract`
Expected: agent-deployment assertions fail before documentation/CI migration.

- [ ] **Step 3: Apply the smallest compatibility migration**

Update only documents necessary to prevent agents from receiving contradictory active instructions. Do not mass-rewrite unrelated narrative/persona uses of words such as `witness` when they are not role identifiers.

- [ ] **Step 4: Run focused and full verification**

Run: `python3 tests/test_agent_deployment.py -v`, `scripts/ava-agent-check --live`, `scripts/ava-ci-contract`, and `git diff --check`.
Expected: all return zero. Search the tree for active-role contradictions and classify every remaining legacy occurrence before accepting the task.

- [ ] **Step 5: Commit**

Commit CI/document compatibility changes separately from agent implementations.

### Task 5: Cross-engine smoke proof and STRIKE recast

**Files:**
- Create: `docs/evidence/agent-deployment-2026-10-02.md`
- Modify only if proof exposes a defect: files owned by Tasks 1-4 plus their tests.

**Interfaces:**
- Consumes: completed deployment.
- Produces: reproducible evidence that canonical agents are discoverable, bounded, and able to hand off evidence without claiming authority.

- [ ] **Step 1: Run a read-only TRACE task in Codex**

Ask TRACE to locate the Master role law and report source paths only. Verify it does not write the worktree.

- [ ] **Step 2: Run a read-only Claude STRIKE task**

Ask STRIKE to challenge one harmless repository invariant using at least two distinct lanes. Verify lane outputs are evidence and no production file is modified.

- [ ] **Step 3: Recast STRIKE against the deployment itself**

Have STRIKE attack permission broadening, recursive fan-out, stale aliases, evidence contamination, and prompt/role authority confusion. Any reproducible finding returns to the owning task for a red/green fix loop.

- [ ] **Step 4: Independent LUX review**

LUX reviews the final diff, tests, evidence ledger, and unresolved limitations without trusting the implementer or STRIKE verdicts.

- [ ] **Step 5: Final verification**

Run the full static contract, agent deployment tests, diff check, and remote-free status checks. Record exact results in the evidence file. Do not merge, release, or rewrite shared history.

- [ ] **Step 6: Commit the evidence checkpoint**

Commit only after fresh verification; Phase 10 integration remains Dawa's choice.