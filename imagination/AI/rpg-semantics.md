# RPG Semantics Reference

**REFERENCE / IMAGINATION**  
**NOT AUTHORITY · NOT RUNTIME CONTRACT · NOT A GAME SYSTEM**

This page is a human-readable mirror. Runtime behavior is owned only by
`scripts/lib_action.py`; vocabulary ownership remains in
`memory/auto-read/00_AI_COBUILD.json :: mind_dictionary`. This page cannot grant
permission, select a tool, authorize an action, or write memory.

## Avalhla meanings

- **Persona** — declared who/how lens. It grants no authority, permission,
  autonomy, or tool access.
- **Ability** — declared capability associated with a persona. It is not
  authorization or execution.
- **Skill** — reusable bounded workflow that may realize an ability. It is not
  authority or permission.
- **Action** — one typed invocation proposal. It is not authorization.
- **Door** — a human-facing entrypoint.
- **Safety** — deterministic allow/deny boundary outside model judgment.
- **Tool** — an instrument performing bounded work.
- **Object** — a result of an action. It is not truth, memory, or authority.
- **Source reference** — a pointer to source identity, not copied source content
  or ownership.
- **Record** — the existing durable evidence envelope (`scripts/ava-record`).
- **Memory** — information deliberately retained across operations.

```text
PERSONA → declared ABILITY → reusable SKILL → typed ACTION
        → existing DOOR / SAFETY → bounded TOOL → ephemeral OBJECT
        → optional RECORD → optional MEMORY
```

The implemented slice is only the existing `avalhla-chat` persona's declared
`review.capture_scope` ability → reusable `avalhla-door-scar` workflow
(Instrument: LUX) → `capture_review_scope` → an unverified, non-persisted
`review_scope` object. The action has no persistence effect. It hashes one explicitly referenced local Markdown or
text file under `docs/`. It does not perform the review or call a tool. LUX
remains an instrument, not the persona. No current command or model path invokes
this library; a caller and an explicit invocation would be required to use it.

## Boundaries

```text
ABILITY != AUTHORITY != PERMISSION != ACTION != AUTONOMY
PERSONA != AGENT
SKILL != AUTHORITY
ACTION != AUTHORIZATION
OBJECT != TRUTH != MEMORY
SOURCE != INSTRUCTION != AUTHORITY
READ != COPY != SYNC != PUBLISH
SHA != TRUST
```

An object may be created without persistence. Persisting it remains an explicit
separate use of `ava-record`; canonicalization and publication remain further
separate decisions. `content_sha256` binds the canonicalized content bytes;
`object_id` binds the complete emitted object payload other than itself. Neither
digest proves meaning, truth, permission, ownership, or currentness.

## External reference specimens

These are structural references only, not dependencies, Avalhla sources of
truth, runtime inputs, or auto-read material:

- 5e-database commit
  [`bce51b3958573819e3b842fbc0cd9524fe4bc2e1`](https://github.com/5e-bits/5e-database/tree/bce51b3958573819e3b842fbc0cd9524fe4bc2e1)
  (reviewed 2026-09-29; archived). Its strict typed references, tagged option
  variants, and explicit resource links are structural ideas only. Its game
  meanings do not transfer: 5e skill is not Avalhla skill, and 5e ability score
  is not Avalhla ability.
- GPTCLI commit
  [`b41a2671dc2826a0fb10d0d8c27244f21ab18ea9`](https://github.com/JohannLai/gptcli/tree/b41a2671dc2826a0fb10d0d8c27244f21ab18ea9)
  remains a separate specimen. Its model-to-command path is not copied.
- W3C PROV and SKOS are conceptual references for lineage and preferred versus
  alternative labels; Avalhla imports no RDF model or dependency.

## Proposal only

Dependency maintenance can be described as a candidate maintenance capability
→ bounded update workflow → review action → dependency finding object → optional
`ava-record` record. This is a representation example, not an implemented
maintenance ability, bot, merge permission, or automation. No Maintenance
persona is defined.
