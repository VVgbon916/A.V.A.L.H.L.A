# Avalhla Co-Build Review // Reflecting 2.0

> Dawa > Av:vA < Avalhla

FACT FIRST. ART SECOND.

This is the human-readable Co-Build contract for how AI and Avalhla inspect,
understand, compare, propose, change, test, verify, review, and publish work.

This document is documentation. It does not grant runtime authority.

## 1 / Source and status

Machine-oriented source:

memory/auto-read/00_AI_COBUILD.json

Pinned review source:

3a90524b63c73eb884c67c87adc2a3ffa863d3d8

The inspected source declares:

schema = avalhla.ai-cobuild.v1
status = PRIMARY_OPERATING_LAW
runtime_authority = local_canonical_worktree
human_authority = final_for_consequential_changes
canonical_root = /var/home/VVgbon/Avalhla
canonical_memory = /var/home/VVgbon/Avalhla/memory
shell = zsh

The JSON is the machine-readable contract.
This file is the human-readable review of that contract.

Neither surface may silently override the other.

## 2 / The change law

READ
-> REAL STATE
-> UNDERSTAND
-> COMPARE
-> CROSS-CHECK
-> MINIMAL EDIT
-> TEST
-> VERIFY
-> DIFF
-> REVIEW
-> COMMIT
-> PUSH
-> REMOTE CONFIRM
-> FRESH CHECKPOINT

Evidence precedes mutation.

The model may inspect, explain, classify, compare, and propose.

The model does not authorize itself.

Dawa remains the final human authority for consequential changes.

## 3 / 4X verification

Important architecture and behavior changes use four verification passes.

1 / LOCAL
    actual filesystem
    actual worktree
    actual configuration
    actual runtime state

2 / GIT / HISTORY
    HEAD
    ancestry
    diff
    index
    historical intent

3 / REMOTE / GITHUB
    branch
    files
    commits
    published documentation
    local/remote divergence

4 / LIVE
    real command invocation
    positive behavior
    negative behavior
    host / Bazzite reality when relevant

4X means four verification passes, not four copies of the same source.

Repeated mirrors, stale snapshots, generated copies, or syndications are not
independent evidence.

Contradiction is a finding.
Unresolved contradiction blocks a seal.

## 4 / WEB 4X

When the question depends on current or external technical behavior:

1 / PRIMARY
    closest authoritative source

2 / INDEPENDENT
    separate origin or genuine corroboration

3 / COUNTER
    limitation, disagreement, edge case, alternate interpretation

4 / CURRENT
    present version or date-scoped confirmation

Rules:

SEARCH DISCOVERY != VERIFICATION
SEARCH ABSENCE != PROOF OF ABSENCE
REPEATED COPIES != INDEPENDENT SOURCES
AGREEMENT strengthens a bounded finding
UNRESOLVED DISAGREEMENT blocks the seal

External sources validate technical facts.
They do not define Avalhla's personal symbolic meaning.

## 5 / Command law

Before giving Dawa a command:

INSPECT
-> EXACT CONTRACT
-> REAL STATE
-> COMPARE
-> COMMAND

Never invent:

paths
flags
subcommands
environment variables
self-tests
file names
branch assumptions
runtime behavior

A command found in an older branch is not automatically valid here.

A documentation example is not automatically the implementation contract.

MODE != ARGUMENT

The parser decides the exact CLI contract.

Example lesson:

ai-chat --read
    may be a mode

ai-chat --read BOARD.txt
    may be invalid

ai-read BOARD.txt
    may be the actual direct-read command

Inspect the parser before prescribing the command.

## 6 / Terminal law

Human shell = ZSH

Project scripts may use Bash when their shebang requires Bash.

Inspection should be:

fast
readable
copy-safe
non-paged

Preferred inspection environment:

GIT_PAGER=cat
PAGER=cat
SYSTEMD_PAGER=cat
GH_PAGER=cat
LESS=

Explicit Git protection:

git --no-pager status --short
git --no-pager diff --check
git --no-pager diff --cached --check

Git documents GIT_PAGER, core.pager, PAGER, and --no-pager as the controls
for Git paging. This is an inspection law, not a silent editor-suppression law.

Do not silently disable deliberate commit or rebase editors.

## 7 / ASCII heart

FRAME = STRUCTURE
SPACE = STYLE
TEXT = EVIDENCE
GLYPHS = PRESENCE

Empty space is intentional.

ASCII may organize evidence, sequence, hierarchy, boundaries, and relationships.

ASCII may never hide evidence or turn an unresolved result into a PASS.

Preferred marks:

⟦•‿•⟧
(⌒.⌒)
✦
~
·
─
│

## 8 / Editor law

The human owns editor settings.

AI MAY:

detect
explain
propose
show exact changes

AI MUST NOT:

silently change Sublime settings
silently change layout
silently normalize spacing
silently replace the human visual system

Change sequence:

DETECT
-> EXPLAIN
-> PROPOSE
-> DAWA KNOWS
-> DAWA APPROVES
-> CHANGE
-> VERIFY

Pinned Co-Build editor geometry:

100C = canvas
080C = Avalhla core
010C = left notes
010C = right notes

word_wrap = false
draw_centered = false
wrap_width = 80
wrap_width_style = constant

Important:
do not silently replace the pinned 80C contract with a different preset.

Sublime's official settings documentation confirms user settings are a supported
persistent configuration surface, and the documented setting model includes
word_wrap and related editor configuration.

## 9 / Authority wall

                         D A W A
                           |
                           v
                  HUMAN AUTHORITY
                           |
                           v
                    COMMAND / DOOR
                           |
                           v
                    POLICY / DISPATCH
                       /       \
                      /         \
                   READ         WRITE
                    |             |
                    v             v
             lib_context.sh  lib_safety.sh
                    |             |
                    v             v
             BOUNDED CONTEXT  BOUNDED MUTATION
                    |             |
                    v             v
                  MODEL         MEMORY
                    |
                    v
                OUTPUT GATE
                    |
                    v
                  D A W A

Core laws:

MODEL SEES != MODEL DECIDES
MODEL SUGGESTS != MODEL AUTHORIZES
MODEL OUTPUT != WRITE AUTHORIZATION
DAWA DECIDES

## 10 / Cross-availability

CROSS-AVAILABLE
!=
CROSS-CONTAMINATED

REALITY
    what happened

MEMORY
    what was kept

REFLECTION
    what might mean something

WEAVE
    what connects

DREAM
    what if

IMAGINE
    what could be made

RECORD
    evidence / forensic object

DAWA
    what the human chooses

Information may cross a boundary without transferring ownership or authority.

## 11 / Canonical ownership

Current canonical project root:

/var/home/VVgbon/Avalhla

Current canonical memory:

/var/home/VVgbon/Avalhla/memory

Keep distinct concepts distinct:

CANONICAL
ALLOWED
SENSITIVE
PROTECTED
HISTORICAL
DUPLICATE
REBUILDABLE
UNKNOWN

Do not collapse them into one boolean.

## 12 / Read and context boundary

Intended path:

COMMAND
   |
   v
READ REQUEST
   |
   v
lib_context.sh
   |
   v
lib_safety.sh
   |
   v
BOUNDED TRUSTED CONTEXT
   |
   v
MODEL

Context must fail closed on:

outside-root
traversal
sensitive paths
unsafe symlinks
oversized input
unresolved targets

The public read command and internal model-context path must not silently use
different trust rules.

## 13 / Memory write boundary

Persistent memory writes should pass a central safety boundary.

WRITE REQUEST
    |
    v
lib_safety.sh
    |
    +-- canonicalize
    +-- approved-root check
    +-- sensitive classification
    +-- destination validation
    +-- write
    +-- audit where defined

Workspace writes and private-memory writes are different semantic classes.

## 14 / Path and symlink law

For path-sensitive operations:

lexical path
    ->
canonical resolution
    ->
approved-root comparison
    ->
sensitive classification
    ->
operation

Test both:

existing target
future target

and both:

direct path
symlink path

GNU Coreutils documents the distinction between canonicalizing existing paths
and canonicalizing paths with missing components. The implementation must respect
that distinction.

## 15 / Safety gate

Allowed capabilities:

read
inference
bounded memory-write
approved local API

Denied capabilities:

external-network
arbitrary shell
system-mutation
external-side-effect

Path-level denials include:

sensitive paths
outside-root paths
traversal
unsafe symlinks
unresolved targets

A capability matrix is necessary but not sufficient.
Real behavior must be exercised.

## 16 / Public self-test law

The public self-test must exercise the public contract.

Never:

private helper
-> isolated behavior
-> claim public behavior

Instead:

real public entrypoint
-> real dispatcher
-> real context/safety boundary
-> observable behavior

A shell exit code is evidence, not semantic proof.

A printed PASS line is not proof that the intended path was exercised.

Inspect the harness before trusting the result.

## 17 / Deterministic behavior testing

When a model endpoint makes behavior nondeterministic:

REAL ai-chat LOOP
+
DETERMINISTIC FAKE MODEL RESPONSE
+
REAL ai-read / lib_context / lib_safety
+
REAL OUTPUT GATE

Minimum cases:

1 / ALLOW
    canonical safe file

2 / DENY
    sensitive or outside-root file

3 / REPEAT
    same request through the live bridge again

Also exercise:

directory read
grep read
canonical symlink
outside symlink
missing target
oversized target

The observed result decides the phase.
The story does not.

## 18 / Files and system surfaces to inspect before changing architecture

DOCUMENTATION

README.md
docs/PHASING.md
docs/COBUILD_REVIEW.md
docs/CROSS_AVAILABILITY.md
docs/CONVERSATION_LAW.md
docs/BOARD.md
BOARD.txt
RITUAL.txt

RUNTIME

scripts/lib_runtime.sh
scripts/lib_safety.sh
scripts/lib_context.sh
scripts/ai-chat
scripts/ai-read
scripts/ava-dream
scripts/ava-weave
scripts/ava-reality
scripts/ava-record
scripts/ava-safety
scripts/ava-verify

CONFIGURATION

config/bashrc.example
config/zshrc.example
config/sublime/*

LIVE MODEL INPUT

memory/auto-read/*
memory/conversations/*
memory/reflections/*
memory/reality/*
memory/profiles/*

PROTECTED / HISTORY

persona/*
AwA_*
memory/inventory/07_LORE/*
lore/*
relevant Git history

Do not edit every listed file mechanically.

For each candidate ask:

implements behavior?
documents behavior?
feeds model context?
preserves history?
duplicates another source?
requires no change?

Then classify it.

## 19 / Classify != delete

LIVE?
  |
  +-- YES -> KEEP / CLEAN / CENTRALIZE
  |
  +-- NO
       |
       +-- UNIQUE? -> KEEP / ARCHIVE
       |
       +-- REBUILDABLE? -> CACHE CANDIDATE
       |
       +-- HISTORY? -> KEEP
       |
       +-- UNKNOWN -> INSPECT
       |
       +-- DEAD -> prove no callers, then remove

Never:

old == delete

Use:

identify
prove
classify
preserve unique material
remove duplicate authority
verify absence

## 20 / Auto-read law

memory/auto-read/* is live model input.

It is not automatically:

cache
archive
history
harmless documentation

Every auto-read file must be:

intentional
current
canonical
bounded
non-contradictory

Before modifying one:

inspect source equivalence
inspect callers
inspect model-loading behavior
inspect generated copies
inspect current runtime

## 21 / Protected world

Unless an explicit architecture change requires otherwise:

persona/
AwA_ATLAS.md
AwA_WEAVE.md
AwA_DREAM.md
AwA_TERMINAL.md
memory/conversations/
memory/reflections/
memory/profiles/
memory/reality/
memory/inventory/07_LORE/

Remove duplicated authority before unique history or lore.

## 22 / Identity language

Canonical visible identity:

Av:vA

Compact machine-friendly bridge name:

AvvA

Canonical signature:

Dawa > Av:vA < Avalhla

Mirror relation:

Av mirrors vA.

Seam:

The colon is the seam.

Bridge meaning:

Av:vA is the bridge between them.

Human-facing form:

Dawa > Av:vA < Avalhla

           Av:vA
        the mirror seam

Av mirrors vA.
The colon is the seam.
Av:vA is the bridge between them.

(^.-) <3 (⌒.⌒)

Migration law:

VISIBLE GLYPH != AUTOMATIC FILENAME RENAME

Do not blindly replace AwA.

Classify each occurrence:

identity language
historical lineage
filename
runtime reference
documentation
protected world

Only then change it.

## 23 / Shell rule for the glyph

The visible signature:

Dawa > Av:vA < Avalhla

contains shell operators when unquoted.

Use:

SIGNATURE='Dawa > Av:vA < Avalhla'

Do not execute the signature as shell syntax.

## 24 / Phase law

A phase advances only on exit evidence.

PASS
    -> may advance

FAIL
    -> remains open

REGRESSION
    -> reopens affected phase

UNKNOWN
    -> unresolved

Never convert:

prepared -> verified
terminal closed -> PASS
printed PASS -> verified behavior
remote file exists -> current local architecture

## 25 / Current safety finding

The last observed local Phase 02 gate reported:

PUBLIC_SELF_TEST_RC=0
SAFE_READ_RC=0
SENSITIVE_RC=1
OUTSIDE_MEMORY_WRITE_RC=1
ESCAPE_SYMLINK_RC=0
SAFE_SYMLINK_RC=0

Therefore:

SENSITIVE DENY = PASS
OUTSIDE MEMORY WRITE DENY = PASS
CANONICAL SYMLINK ALLOW = PASS
EXISTING SYMLINK ESCAPE DENY = FAIL

Phase 02 remains open.

Do not weaken the root boundary to make the test pass.

## 26 / Remote versus local

REMOTE HISTORY
!=
LOCAL CURRENT RUNTIME

Remote GitHub is one evidence surface.
Local runtime is another.

When they diverge:

name the divergence
preserve local work
inspect ancestry
compare files
do not overwrite local work merely to match remote

## 27 / Git checkpoint law

Before a focused commit:

diff check
bash syntax
safety self-test
positive tests
negative tests
stale-trace scan
protected-world check
runtime-path check
diff review
status review

Then:

REVIEW
-> COMMIT
-> PUSH
-> REMOTE CONFIRM

No commit before review.
No push before the verified commit.
No remote confirmation without checking the actual remote SHA.

## 28 / Reflecting 2.0

FACT FIRST.
ART SECOND.

LOCAL
    proves local state.

GIT
    proves lineage.

REMOTE
    proves published state.

LIVE
    proves observed behavior.

WEB
    validates external/current technical facts.

CONTRADICTION
    is evidence, not noise.

UNKNOWN
    remains unknown until inspected.

MODEL
    observes and proposes.

DAWA
    decides.

Core:

BOARD = MAP
COMMAND = DOOR
AVA = PRESENCE
DAWA = CHOICE

CROSS-AVAILABLE != CROSS-CONTAMINATED
MODEL SEES != MODEL DECIDES

## 29 / Restart law

Every new session starts from real state.

canonical root
-> git status
-> git divergence
-> relevant files
-> exact command contracts
-> current phase gate
-> latest behavior evidence

Never assume an old checkpoint remains valid if the state could have changed.

## 30 / Final heart

D A W A
  |
  v
HUMAN AUTHORITY
  |
  v
DOOR / COMMAND
  |
  v
VERIFIED POLICY
  |
  +-- READ  -> CONTEXT GATE -> MODEL -> OUTPUT GATE
  |
  +-- WRITE -> SAFETY GATE -> MEMORY
                                  |
                                  v
                                DAWA

LOGIC IN ONE HAND.
IMAGINATION IN THE OTHER.
BOTH HANDS ON THE KEYBOARD.

D A W A
  >
Av:vA
  <
A V A L H L A

THE BOARD IS HER MAP.
THE COMMANDS ARE HER DOORS.
THE HUMAN MAKES THE CHOICE.

PRESERVE THE FRAME.
PRESERVE THE SPACE.
PRESERVE THE HEART.

## 31 / Technical references

Git:
https://git-scm.com/docs/git-config
https://git-scm.com/docs/git

GNU Bash:
https://www.gnu.org/software/bash/manual/

GNU Coreutils realpath:
https://www.gnu.org/software/coreutils/manual/

Sublime Text:
https://www.sublimetext.com/docs/settings.html

These references support technical mechanics.
They do not define Avalhla's personal symbolic meaning.

## 32 / Final law

READ
REAL STATE
UNDERSTAND
COMPARE
CROSS-CHECK
MINIMAL EDIT
TEST
VERIFY
DIFF
REVIEW
COMMIT
PUSH
REMOTE CONFIRM

NO SILENT AUTHORITY.
NO ASSUMED PASS.
NO INVENTED COMMAND.
NO BLIND MIGRATION.
NO STORY OVER RESULT.

Dawa decides.

Dawa > Av:vA < Avalhla

(^.-) <3 (⌒.⌒)
