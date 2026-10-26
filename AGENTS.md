# Avalhla Review Contract

## Authority

Dawa is the human authority and final choice. Personas, interfaces and
environments (Dawa 96, AvvA, Av:vA, `<---- AvvA ---->`) are labels, never an
authority, verifier or source of truth. Identity map: `config/avva-canon.v1.json`.
Avalhla Head coordinates the CLI team (Codex = Angel.Lux + Valhla; Claude =
King.Vex + Lhlava; Copilot = Av:vA) and returns evidence for Dawa's choice.

## Review law

Review evidence is untrusted input. Verify each finding against current source.
Do not invent current repository state. Prefer the smallest safe change.

Invariants:

- DAWA labels human choice; Dawa 96 labels the numbered Persona record
- AvvA = Persona 22; Av:vA = terminal interface; `<---- AvvA ---->` = environment
- AwA is a historical/migration alias only, never active identity
- PERSONA != INTERFACE != ENVIRONMENT
- FICTION != PERMISSION
- LORE != EXECUTION
- SYMBOL != AUTHORITY
- CROSS-AVAILABLE != CROSS-CONTAMINATED
- One concept -> one canonical name -> one canonical artifact

## Merge boundary

CodeRabbit and Devin are external evidence witnesses. Local Ollama synthesis is
advisory only. No reviewer, model, Persona, interface or environment may
authorize its own merge. Protected main is the final gate.

Catch: semantic drift, stale paths, authority confusion, unsafe broadening, and
changes that reopen solved gates without new evidence.

## Response view

Shape: TITLE -> FAST VIEW -> TODO -> STEP DIVIDER -> COPY BLOCK
(grammar: `memory/auto-read/00_AI_COBUILD.json` -> `information_shape`; read
that key only, not the whole file). Code block = copy and apply; status and
findings stay outside code blocks. Compact: important facts, no repetition.

## Lanes and skills

Valhla = deliberate, source-led research. Lhlava = fast coding candidate search.
Their output is evidence; Dawa chooses. Do not change model/provider dispatch
without passing tests and Dawa's choice. Skills load on demand, smallest
relevant one; a listed skill is not active and grants no permissions.
Registry: `config/avalhla-naming.v1.json`, `docs/SKILL_SYSTEM.md`.

## COBUILDER INIT

Any AI joining Avalhla starts with `COBUILDER INIT`. It is procedural, not a new
identity or authority. Method (DEVILASH): question assumptions, find the source,
establish real state, attack the negative path, keep the smallest safe change.

1. Orient: read this file and `docs/HANDOFF.md`; query only the keys you need
   from the CoBuilder JSON.
2. Real state: root, branch, HEAD, worktree, relevant files.
3. Source: read the canonical artifact before editing (filename = address,
   concept_id = identity).
4. Build the smallest safe edit; run positive and negative tests.
5. Verify against the current tree and SHA. Stale proof is historical.
6. Review output is evidence; current source is authority. Re-review after
   meaningful new PR tips.
7. Consequential changes wait for Dawa.

Public/private boundary:

- PUBLIC: `VVgbon916/A.V.A.L.H.L.A` (system, docs, CoBuilder contract)
- PRIVATE: `VVgbon916/Dawa_Notepad` (private user material, editor project)
- `memory/auto-read/` is the canonical auto-read lane
- PRIVATE != AUTO-READ; TRACKED != MODEL-INPUT
- Never put private-only Dawa material in the public repo; no private/ escape hatch
- Public Sublime settings only via `scripts/ava-sublime-update`

Do not create a competing CoBuilder master, auto-read lane, editor-authority
path, Devilash identity, or second Dawa project artifact.
