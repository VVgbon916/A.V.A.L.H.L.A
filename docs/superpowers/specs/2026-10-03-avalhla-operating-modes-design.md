# Avalhla Operating Modes Architecture

## Intent

Make improving Avalhla the default purpose while preserving CoBuilder, DEVILASH, safety, review, memory, provenance, and human-authority contracts. External AI systems may inspect, research, design, code, test, and review, but capability never implies authority.

## Top-level modes

- `ava` / `ava build` — improve Avalhla; default workflow.
- `ava solo` — Avalhla-only operation; no external AI delegation.
- `ava party` — Avalhla orchestrates external coding/research specialists such as Codex and Claude.
- `ava council` — convergent deep research on one QUEST using Avalhla's canonical aspects/lenses plus optional external researchers.
- `ava modes` — discover the operating surface.

Existing inspect, research, devil, test, review, resume, status, memory, safety, provenance, and phase capabilities remain supporting capabilities rather than competing top-level purposes.

## Authority

Dawa remains final human authority for consequential changes. AvvA is relation / living threshold, never an agent or authority. Avalhla is the primary orchestrator. BUILD is the default objective; SOLO, PARTY, and COUNCIL alter execution topology, not authority.

BUILD invokes only the supporting capabilities justified by evidence, uncertainty, blast radius, and trust-boundary exposure. Higher-risk work may escalate into forensic inspection, research, DEVILASH, negative testing, regression, and review.

## PARTY

PARTY members are coding workers, not research-only assistants. A worker may read, search, research, design, edit code, create tests, run permitted tests, attack assumptions, review, and produce candidate diffs.

Each concurrent writer owns an isolated Git worktree/branch. Independent writers do not mutate the same worktree. Worker output returns to Avalhla as candidate code plus evidence, tests, provenance, limitations, and unresolved conflicts.

A PARTY member cannot self-approve, self-seal, authorize consequential actions, merge canonical state, bypass required gates, or decide for Dawa. Provider/model identity grants no extra authority.

## COUNCIL

COUNCIL differs from PARTY: PARTY performs parallel work; COUNCIL performs convergent deep research.

A COUNCIL run has one QUEST. Avalhla, Lux, Vex, Valhla, Lhlava, DEVILASH, and optional external researchers examine the same question through canonical lenses. Contributions are evidence, not votes or authorities. Contradictions remain explicit and block sealing when the applicable contract requires resolution.

Exact meanings of named aspects/lenses come from canonical repository vocabulary; this architecture does not silently redefine them.

## D&D-style semantic layer

Keep the D&D-inspired human vocabulary while separating it from machine authorization semantics. Canonical concepts may include QUEST, REALM, PRESENCE, ASPECT, PARTY, ROLE, ABILITY, SKILL, ACTION, SOURCE, LORE/MEMORY, TRIAL/TEST, WARD/GUARDRAIL, and GATE where they fit the existing concept dictionary.

Metaphorical vocabulary never grants permission. REALM, PRESENCE, ASPECT, ROLE, ABILITY, SKILL, PARTY membership, provider identity, and persona are not authority.

Migration distinguishes canonical terms, aliases, historical names, executable identifiers, and prose/lore. Historical evidence is not blindly renamed.

## Evidence crossing

External workers return a structured evidence envelope containing at least QUEST/task identity, worker/provider identity, role, scope, findings or patch reference, tests, sources when applicable, contradictions, unknowns, limitations, and proposed actions. Authority classification remains evidence/candidate-work only.

Model output never authorizes its own side effect. Existing model-input, display, ingest, and human-authority distinctions remain intact.

## Review and mutation gates

Evidence-before-mutation remains foundational. Candidate work follows the applicable chain:

`ORIENT/FORENSIC -> PLAN/RESEARCH/DEVILASH as justified -> MINIMAL IMPLEMENTATION -> POSITIVE + NEGATIVE TESTS -> REGRESSION/CONTRACT VERIFY -> STRUCTURED REVIEW -> DAWA HUMAN GATE`

Existing deterministic review grammar and DEVILASH restrictions remain unless a separately reviewed migration replaces them with an equivalent or stronger contract.

## Repository migration

Do not perform a repository-wide search-and-replace. First inventory names/concepts and classify occurrences as machine vocabulary, executable identifier, canonical human vocabulary, lore, compatibility alias, or historical record. Build a dependency map before renaming anything consumed by scripts, tests, prompts, systemd, configuration, or memory contracts.

Migration proceeds in independently testable slices with positive/negative tests where meaningful, deterministic contract validation, diff review, and compatibility preservation where required.

## Discovery UX

```text
ava              # BUILD
ava build
ava solo
ava party
ava council
ava modes
ava help
```

Detailed subcommands are added only for real implementation needs. Do not turn every persona, aspect, provider, or verification instrument into a top-level mode.

## Invariants

1. Improve Avalhla is the default objective.
2. `ava` and `ava build` are equivalent at routing level.
3. SOLO excludes external AI delegation without disabling Avalhla safety/review capabilities.
4. PARTY permits coding, but concurrent writers are isolated.
5. COUNCIL researches one QUEST and does not become voting authority.
6. Capability, persona, aspect, role, provider, and model identity do not grant authority.
7. Model output is evidence/candidate work, not authorization.
8. Existing safety, provenance, review, and human gates remain alive.
9. D&D language is a human semantic layer, not a permission system.
10. Dawa chooses.

## Success criteria

A fresh worker/chat discovers the operating contract from canonical repository artifacts without conversation history. `ava` starts improving Avalhla; SOLO isolates; PARTY enlists coding specialists; COUNCIL invokes whole-system deep research. Existing gates remain mechanically testable, external coding is isolated and attributable, and vocabulary has one canonical concept map with explicit aliases and historical exceptions.
