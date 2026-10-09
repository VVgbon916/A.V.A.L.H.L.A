# Door activation

## Skill activation

The native skills named in `config/avalhla-naming.v1.json` are intended to be
**on demand**.
Having a skill installed, listing it in `ava-help`, or seeing it in an editor
does not mean it is active. Select the smallest relevant skill for the task;
do not load every skill by default. Use the full 8× chain only when Dawa asks
for it or the change's gate requires it.

Skill instructions are workflow guidance, not executable permissions. The
assistant's actual sandbox, tool, and approval controls remain authoritative.
Report only skills and tools actually used; do not imply that another model,
agent, plugin, or reviewer ran.
This registry is a native-assistant workflow contract, not a local skill
loader or provider dispatcher.

## Normal Avalhla use

Use the smallest relevant door.

Examples:

```text
"Show me what is actually here"       → THRESHOLD
"Where did this come from?"            → THREAD
"Is this boundary safe?"               → WARD
"Where is this actually implemented?"  → LENS
"Try to break this"                    → FANG
"Review this exact patch"              → SCAR
"Did this break anything?"             → ECHO
"Challenge the conclusion"             → LANTERN
```

## Full engineering mode

Use the full chain when Dawa asks for `8x`, `full attack`, `Devil mode`, `DevilAsh`, or equivalent:

```text
THRESHOLD
  ↓
THREAD
  ↓
WARD
  ↓
LENS
  ↓
FANG
  ↓
SCAR
  ↓
ECHO
  ↓
LANTERN
  ↓
DAWA
```

## Interchangeability

Skills are reusable and can be invoked individually.

They are not permission-equivalent.

- WITNESS/LUX = read-only
- VEX/ECHO = isolated tests/fixtures as needed
- FORGE = local workspace write
- GitHub write = explicit Dawa authorization
