# Door activation

## Normal Avalhla use

Use the smallest relevant door.

Examples:

```text
"Show me what is actually here"       → ORIENT
"Where did this come from?"            → TRACE
"Is this boundary safe?"               → BOUNDARY
"Where is this actually implemented?"  → INSPECT
"Try to break this"                    → STRIKE
"Review this exact patch"              → DIFF
"Did this break anything?"             → REPRISE
"Challenge the conclusion"             → LANTERN
```

## Full engineering mode

Use the full chain when Dawa asks for `8x`, `full attack`, `Devil mode`, `DevilAsh`, or equivalent:

```text
ORIENT
  ↓
TRACE
  ↓
BOUNDARY
  ↓
INSPECT
  ↓
STRIKE
  ↓
DIFF
  ↓
REPRISE
  ↓
LANTERN
```

Dawa chooses after the evidence is presented. Dawa is not a ninth door.

## Interchangeability

Skills are reusable and can be invoked individually.

They are not permission-equivalent.

- WITNESS/LUX = read-only
- VEX/ECHO = isolated tests/fixtures as needed
- FORGE = local workspace write
- GitHub write = explicit Dawa authorization
