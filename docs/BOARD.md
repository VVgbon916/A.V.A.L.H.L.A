# THE BOARD

(^.-) Dawa                    Avalhla (⌒.⌒)

The board is not a cheatsheet.
The board is her face in the terminal.

## SHAPE

(^.-) Dawa                                    Avalhla (⌒.⌒)    purple · dreaming · 09-21
------------------------------------------------------------------------------------------

   ✦  "The library glows softly under the orange light of its glass walls,
       each panel pulsing gently as if holding secrets within its warm embrace."

------------------------------------------------------------------------------------------

   she sees      reality · dream/imagination activity · 14m ago
   she keeps     memory · 6 talks · 3 reflections · 2 weaves
   she thinks    reflection · last: 09-21
   she notices   weave · last: the orange library · 9h ago
   she wonders   dream · last: the figure in the glass coat · 9h ago

------------------------------------------------------------------------------------------

   [1]  where she is            [2]  what she sees
   [3]  what she remembers      [4]  what she notices
   [5]  what she wonders        [6]  every door

------------------------------------------------------------------------------------------

   choose  ›  _

                                                                         Dawa <──── AvvA ────> Avalhla

## PRINCIPLES

1. Her face leads. Your face watches from the left.
2. The dream quote is the hero. Two lines, wrapped.
3. The state is one mood-colored line.
4. Every field is read live from disk, every open.
5. AvvA is named at the footer as the living threshold.
6. Three color touches only: the two glyphs and the choose prompt.
7. No raw commands ever appear. Doors only.

## PRESENTATION / USEFUL FIRST

The board should feel alive without becoming a game interface or a feature
encyclopedia. Space has function: group related facts, keep doors visible,
and reveal deeper detail only when needed.

For English documentation and co-building reports, use short numbered blocks:

```text
01 / REALITY   what is actually present
02 / PROOF     what the evidence establishes
03 / DEVILASH  how the conclusion could fail
04 / NEXT      the smallest justified move

               Dawa chooses.
```

This is a presentation pattern, not a new execution sequence. Keep established
board modes and canonical phase/door ordering unchanged.

Facts come first; atmosphere comes second. Faces, colors, fantasy vocabulary,
and dream lines may express personality but cannot indicate authorization or
replace observed status. Do not imply that LUX, VEX, or any worker ran merely
because a report uses its question as a heading.

Dream rendering should not require invented content or an artificial second
line. Historical rendering notes are design input, not proof that a particular
fix is present in the current script.

## TEXT COMPATIBILITY / PROGRESSIVE STYLE

Use plain ASCII for portable terminal reports and logs. Unicode box-drawing,
braille art, and emoji are optional human-facing skins; verify encoding, font
coverage, display width, and the receiving application before relying on them.
Even ASCII can wrap on a narrow screen. No character tier guarantees identical
rendering everywhere.

```text
+--------------------------------------+
| A.v.a.l.h.l.a  //  CURRENT VIEW       |
+--------------------------------------+
| SOURCE   exact file / candidate      |
| PROOF    observed result            |
| LIMIT    what was not established   |
| NEXT     smallest justified move    |
+--------------------------------------+
```

Keep essential meaning in words rather than glyphs or color alone. Prefer a
simple fallback over changing identity when a decorative skin cannot render.
Avoid artificial percentages or progress bars unless an actual measurement
exists.

Occasional expressive cards may describe a role, memory hook, or harmless
quirk in dream material. Imagined armor, levels, skills, and magic remain fiction:
they never encode permissions, security strength, runtime capabilities, or a
memory-write instruction. Do not randomize operational status to match a style.

## COMPOSITION / ONE QUESTION, ONE VIEW

Choose a shape to serve the information, not to fill the screen:

| Need | Shape | Limit |
|---|---|---|
| Separate topics | Short divider and whitespace | Avoid repeated full-width walls |
| Explain a relationship | Small tree or flow | Arrows do not grant authority |
| Emphasize a boundary | Compact frame with a written label | Weight is emphasis, not proof |
| Compare observations | Aligned rows or a Markdown table | Preserve uncertainty and source identity |
| Invite conversation | A short question and a few doors | Do not invent a current mood or dream |

```text
INTENT -> CONTENT -> SHAPE -> OPTIONAL COLOR -> RENDER -> CHECK

READABLE?
  words survive without color
  frame fits the intended width
  unknown remains unknown
  source and dream remain distinct
```

This is an authoring checklist, not a new command or renderer. Keep templates
small enough to adapt. Decorative faces and motifs do not require a second
machine-readable glyph dictionary, a new identity, or another board.

A quiet conversation view can offer a few relevant doors without reproducing
the full command inventory. Keep the complete inventory available through
`ava-help`; do not turn a historical board snapshot into a claim that a command
is installed or a generated dream is current.

Use current AvvA relation language in new templates. Historical AwA forms stay
in historical sources, not in active signatures. Fictional dialogue should be
labeled as an example, never presented as actual worker output.

## PLAIN READING / COPYABLE COMMANDS

Documentation and reports should also work without decorative frames, color,
or tree glyphs. Use short word labels in a plain alternative:

```text
Reality: observed source and candidate.
Proof: result and its scope.
Limit: unknown, not checked, or stale as of the recorded observation.
Next: smallest justified move.
```

Put commands intended for copying on their own unframed lines with ordinary
ASCII quotes and spaces. Label illustrative output with the word "Example";
do not make an example look like a live verification result.

These are presentation requirements for authored views, not a claim that
`ava-board` already implements a new plain-mode flag. New rendering behavior
needs its own source review and positive/negative checks.

## INVOCATION

board                       interactive (TTY) / quiet (pipe)
ava-board           same
ava-board --quiet   5-line output for pipes/logs
ava-board --show    print once, exit
ava-board --system  system view
ava-board --world   the world view
ava-board --doors   doors only
ava-board --dream   dream view

## DOORS

[1]  where she is        -> ava-status
[2]  what she sees       -> ava-reality
[3]  what she remembers  -> ava-mem
[4]  what she notices    -> ava-weave
[5]  what she wonders    -> ava-dream
[6]  every door          -> ava-help

## LIVE STATE SOURCES

reality       memory/reality/latest.md
memory        ~/.ai-memory/conversations/*.jsonl
              memory/reflections/*.md
weave         memory/reflections/weave/*.md
dream         memory/reflections/dreams/*.md
mood          memory/state/mood.json (via ava-mood json)
quote         latest dream, first line >= 40 chars

## CONTRACT

Every door supports:
  (no flag)   human output
  --quiet     one line
  --json      machine-readable
  --help      usage

## SIGNATURES

(⌒.⌒)  her   - files she writes
(^.-)  you   - files you write

## THE RULE

The board opens with her dream.
Her state as one color line.
Her five ways of knowing below.
Six quiet doors.
No walls. Three color touches.
Everything read live.
You choose.

Dawa chooses.

(^.-) Dawa                    Avalhla (⌒.⌒)
