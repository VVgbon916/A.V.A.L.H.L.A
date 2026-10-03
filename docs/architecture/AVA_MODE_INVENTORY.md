# Avalhla Mode Migration Inventory

Status: Task 1 forensic inventory for the operating-modes architecture.

Invariant: `NO_BLIND_RENAME`.

Authority: evidence and candidate code do not authorize consequential integration. Dawa chooses.

## Classification vocabulary

| Class | Meaning | Migration rule |
|---|---|---|
| `EXECUTABLE` | Shell/Python/system integration consumed as executable behavior | Trace callers and tests before changing names or semantics. |
| `CANONICAL_HUMAN` | Current human-facing terminology and command/documentation surface | May migrate after concept ownership is established. |
| `MACHINE_CONTRACT` | JSON/schema/config/test grammar interpreted mechanically | Version and validate; never prose-only migration. |
| `COMPATIBILITY` | Alias or legacy interface still required by callers/users | Preserve until explicit compatibility test permits removal. |
| `LORE` | Narrative, persona, art, dream, ritual, or world-language content | Preserve voice; migrate only when semantic intent is canonical, not by raw replacement. |
| `HISTORICAL` | Evidence of prior names/states whose age is meaningful | Keep historical truth; annotate/index rather than rewrite. |

## Repository surfaces

| Surface | Primary class | Why it matters for mode migration |
|---|---|---|
| `scripts/` | `EXECUTABLE` | Existing `ai-*` and `ava-*` entrypoints are capabilities the new thin `ava` router must compose rather than replace blindly. |
| `memory/auto-read/00_AI_COBUILD.json` | `MACHINE_CONTRACT` | Existing CoBuilder law and authority/evidence semantics; new operating-mode contract should be referenced here without duplicating its complete semantics. |
| `persona/` | `LORE` + `CANONICAL_HUMAN` | Contains chat/code/review model files and system prompt. Persona language may describe modes but cannot grant permissions. |
| `config/` | `MACHINE_CONTRACT` | Configuration consumers require versioned, deterministic changes. Target home for the operating-mode contract is `config/ava/`. |
| `systemd/` | `EXECUTABLE` + `COMPATIBILITY` | Runtime/service names and paths can be compatibility-sensitive. Inspect before vocabulary migration. |
| `tests/` | `MACHINE_CONTRACT` | Positive and negative gates define behavior and prevent semantic drift. |
| `.github/workflows/` | `MACHINE_CONTRACT` | CI/static-contract enforcement must eventually include the new mode contracts/tests. |
| root human docs (`README.md`, `BOARD.txt`, `COMMANDS.txt`, `QUICKREF.txt`, `RITUAL.txt`) | `CANONICAL_HUMAN` + `LORE` | Discovery and identity surfaces; migrate only after executable/contract ownership is stable. |
| `docs/` | `CANONICAL_HUMAN` + `HISTORICAL` | Architecture, phasing, source-map and handoff evidence; distinguish current law from historical records. |

## Legacy AwA artifacts

The following root artifacts are explicitly classified before any rename:

| Artifact | Class | Current migration treatment |
|---|---|---|
| `AwA_ATLAS.md` | `HISTORICAL` + `LORE` | Preserve name/content during operating-mode implementation; later semantic-map task may add canonical alias/index. |
| `AwA_DREAM.md` | `HISTORICAL` + `LORE` | Preserve; dream history is not an executable identifier migration. |
| `AwA_TERMINAL.md` | `HISTORICAL` + `COMPATIBILITY` candidate | Inspect references before any rename because terminal instructions may be copied by users/scripts. |
| `AwA_WEAVE.md` | `HISTORICAL` + `LORE` | Preserve until vocabulary dependency map proves a safe canonical migration. |

`AwA` occurrences are therefore not evidence that every occurrence should become `Av:vA`, `AvvA`, or `Avalhla`. Context determines concept identity.

## Command surface ownership

### Existing capability layer

Existing `scripts/` entrypoints remain capability implementations. Observed examples include `ai-ask`, `ai-chat`, `ai-learn`, `ai-read`, `ai-remember`, `ai-system-status`, `ava-audit`, `ava-autoread`, and `ava-board`.

### New orchestration layer

The planned `scripts/ava` entrypoint owns only top-level mode routing/discovery:

- no argument / `build` -> BUILD
- `solo` -> SOLO
- `party` -> PARTY
- `council` -> COUNCIL
- `modes` / `help` -> discovery

It must not duplicate lower-level safety, review, memory, provider, or provenance implementations.

## Authority-sensitive consumers

The following surfaces require explicit review before mode integration because mistakes could turn descriptive language into executable authority:

1. `memory/auto-read/00_AI_COBUILD.json` — canonical CoBuilder machine-readable law.
2. `persona/` — model-facing instructions; persona statements are not permission checks.
3. provider/model dispatch call sites under `scripts/` — SOLO must eventually enforce at this boundary.
4. action/integrity/review/provenance helpers and their tests — PARTY evidence must cross existing deterministic boundaries rather than bypass them.
5. `.github/workflows/` and static-contract tests — final mechanical gate.
6. `systemd/` and `config/` runtime consumers — path/name changes can alter actual runtime behavior.

## Concept ownership before migration

| Concept | Planned canonical owner | Notes |
|---|---|---|
| BUILD / SOLO / PARTY / COUNCIL | `config/ava/operating-modes.v1.json` | Versioned machine contract; human docs point to it. |
| CoBuilder authority/evidence law | `memory/auto-read/00_AI_COBUILD.json` plus its existing canonical sources | Extend by pointer/summary only where possible. |
| D&D semantic vocabulary | canonical concept registry selected/created in Task 8 | Preferred names, aliases, scopes and authority-negative semantics. |
| provider capabilities | `config/ava/providers.v1.json` | Provider identity never grants authority. |
| PARTY worker envelope | `config/ava/party-worker.v1.json` | Candidate-work/evidence classification only. |
| COUNCIL lenses | existing canonical aspect definitions + `config/ava/council.v1.json` | Do not invent meanings for Lux/Vex/Valhla/Lhlava. |

## Dependency rules

1. Trace `EXECUTABLE` and `MACHINE_CONTRACT` consumers before rename/edit.
2. Preserve `COMPATIBILITY` aliases until tests prove removal is safe.
3. Never rewrite `HISTORICAL` evidence merely to make current naming uniform.
4. `LORE` may share words with machine vocabulary but does not define executable semantics.
5. A human-facing D&D term can map to a machine concept, but the term itself never grants authority.
6. The mode router composes existing capabilities; it does not become a second safety/review implementation.

## Task 1 exit

This inventory establishes the migration classes and known authority-sensitive surfaces required before creating the operating-mode contract. It intentionally does not rename legacy artifacts or implement modes.
