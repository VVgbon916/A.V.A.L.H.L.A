# AVALHLA ARCHITECTURAL MASTER
## Dawa + AvvA + Avalhla | Context, Evidence, Authority, 8X, Memory, Codex, DevilAsh

> Canonical human-readable architectural master for the Avalhla Co-Builder system.
> This document is an expanded architectural view. It does not grant authority to
> a model, agent, skill, tool, MCP server, memory record, color, review system, or
> generated artifact.

---

## 0. HEART

```text
                    D A W A
                       |
                       | human choice
                       v
                 +-----------+
                 |   AvvA    |
                 | relation  |
                 | crossing  |
                 +-----+-----+
                       |
          +------------+-------------+
          |            |             |
          v            v             v
       REALITY      EVIDENCE      EXPRESSION
       AVALHLA       8X / SHA       COLOR
          |            |             |
          +------------+-------------+
                       |
                       v
                    DEVILASH
                       |
                       v
                     DAWA
```

Core laws:

```text
Dawa chooses.

AvvA is relationship.
AvvA is not authority.
AvvA is not a verifier.
AvvA is not a source of truth.

Avalhla is presence / reality-facing system.

BOARD  = MAP
COMMANDS = DOORS
AVALHLA = PRESENCE
DAWA = CHOICE

Evidence precedes mutation.
Boundary precedes read.
Provenance precedes trust.
Attack precedes confidence.
Recompare precedes conclusion.
Dawa precedes publication.
```

The architectural objective is not to make Avalhla opaque, omnivorous, or
self-authorizing. The objective is to make the crossing between Dawa, data,
tools, memory, evidence, and action visible and bounded.

---

## 1. IDENTITY LAYER

The system uses typed identities. A name appearing in more than one namespace
must be intentional and explicit.

```text
VALHLA
= historical Voice of Wisdom
= historical/reference layer

LHLAVA
= historical Voice of Anger / pressure toward finding a solution
= historical/reference layer

AVALHLA
= Voice of Reality
= current reality-facing lens / presence

LUX
= ONE Angel
= clarity / review / care lens
= no authority

VEX
= ONE Demon
= adversarial challenge / fracture / assumption-breaking
= no authority

AvvA
= co-building relationship
= living threshold
= continuity between discussions
= no authority
```

Namespace law:

```text
VOICE
!= INSTRUMENT
!= DOOR
!= SKILL
!= AGENT
!= AUTHORITY
```

Intentional reuse must be typed. For example, `VEX` may exist as both
`voice.VEX` and `instrument.VEX`, while `ECHO` may exist as both an engineering
door and regression instrument. Equality of spelling is never proof of equality
of meaning.

`VIGIL` remains a proposal for a reviewer instrument until explicitly chosen.
`LUMEN` remains a proposal for the sole Angel name if the project later separates
review instrumentation from the Angel identity. No proposal becomes canonical
by repetition.

---

## 2. AUTHORITY SPINE

```text
DAWA
  |
  v
CHOICE
  |
  v
COMMAND / DOOR
  |
  v
DETERMINISTIC BOUNDARY
  |
  +-------------------+
  |                   |
  v                   v
APPROVED READ     APPROVED ACTION
  |                   |
  v                   v
EVIDENCE          EXECUTION
  |                   |
  +---------+---------+
            v
         REPORT
            |
            v
          DAWA
```

No lower layer can promote itself upward.

```text
MODEL OUTPUT        != AUTHORIZATION
REVIEW FINDING      != AUTHORIZATION
CI PASS             != AUTHORIZATION
ANGEL               != AUTHORIZATION
DEMON               != AUTHORIZATION
AvvA CONTINUITY     != AUTHORIZATION
TOOL AVAILABILITY   != AUTHORIZATION
GIT TRACKED         != MODEL INPUT
```

A model can propose that something is safe or unsafe. The system must still
route consequential authority to the human gate.

---

## 3. SOURCE ONTOLOGY

Avalhla must not use one overloaded meaning of `context`.

### Source class

```text
CANONICAL
DERIVED
HISTORICAL
WITNESS
PRIVATE
GENERATED
EXTERNAL
UNKNOWN
```

### Discovery state

```text
KNOWN
AVAILABLE_BUT_UNREAD
UNKNOWN
```

### Access state

```text
AUTHORIZED
NOT_AUTHORIZED
```

### Evidence state

```text
VERIFIED
UNVERIFIED
CONFLICTING
```

### Currency state

```text
CURRENT
HISTORICAL
STALE
REQUIRES_RECHECK
```

### Tool state

```text
AVAILABLE
ENABLED
AUTHORIZED
USED
TRUSTED
```

These dimensions are independent.

A source may therefore be:

```text
KNOWN
PRIVATE
AVAILABLE_BUT_UNREAD
NOT_AUTHORIZED
HISTORICAL
```

without contradiction.

---

## 4. THE CONTEXT INTAKE SPINE

The smallest complete architecture is not a giant prompt and not a full dump of
every repository or private notebook.

```text
SOURCE INVENTORY
       |
       v
SOURCE MANIFEST
       |
       v
EXPLICIT AUTHORIZATION
       |
       v
BOUNDED READ
       |
       v
PROVENANCE + HASH
       |
       v
CONTEXT PACKAGE
       |
       v
CODEX
```

The manifest is a navigation/provenance map.
It is not a second semantic authority.

Minimum manifest concepts:

```text
source_id
source_kind
locator
canonical_status
privacy_status
authorization_state
version_or_commit
source_sha256
size
modified_at
allowed_use
forbidden_use
derived_from
last_verified
```

Never let a manifest silently grant access. Authorization remains a separate
human-controlled operation.

---

## 5. DAWA_NOTEPAD BOUNDARY

```text
PRIVATE != AUTO-READ
PRIVATE != PUBLIC
PRIVATE != MODEL INPUT
PRIVATE != COPY AUTHORIZATION
PRIVATE != SYNC AUTHORIZATION
```

Operations are separate:

```text
DISCOVER
METADATA
READ
COPY
SYNC
PUBLISH
```

Permission does not cascade:

```text
READ  != COPY
COPY  != SYNC
SYNC  != PUBLISH
```

The private Dawa lane must remain outside the public Avalhla canonical read lane.
Editor visibility does not grant ingestion authority.
Git tracking does not grant model-input authority.

A future private-source flow, if Dawa explicitly chooses it, should identify:

```text
WHAT
WHY
SCOPE
TIME
PURPOSE
PROVENANCE
REVOCATION
```

Do not create an always-on private mirror simply because broad context feels
convenient.

---

## 6. CODEX OPERATING POSTURES

Different work requires different containment.

### FORENSIC

```text
sandbox = read-only
approval = on-request
```

Use for 8X investigation, audits, review, source mapping, and DevilAsh.

### BUILD

```text
sandbox = workspace-write
approval = on-request
```

Use only for an explicitly authorized implementation task.

### RESEARCH

Enable live web search only when the task requires current external evidence.

### PUBLICATION

Publication remains a separate Dawa decision:

```text
VERIFY
-> DIFF
-> REVIEW
-> HUMAN CHOICE
-> COMMIT / PUSH / MERGE
```

Do not turn the implementation posture into an implicit publication posture.

---

## 7. OPENAI TOOLING LAYER

Tooling is capability, not authority.

```text
CODEX
= execution / research / coding layer

SKILL
= reusable workflow instruction

MCP
= bounded capability / external system interface

PLUGIN
= packaged workflow + capability surface

DEVILASH
= adversarial verification method

DAWA
= final human choice
```

Use the official OpenAI Developer Docs MCP for current OpenAI/Codex questions
when appropriate. It is documentation-only and read-only.

Do not install every available plugin, MCP server, or skill.

For any new capability:

```text
DISCOVER
-> CLASSIFY
-> VERIFY SOURCE
-> DEFINE SCOPE
-> SHOW EXACT CHANGE
-> DAWA APPROVAL
-> INSTALL / ENABLE
-> VERIFY
```

Available does not mean enabled.
Enabled does not mean authorized.
Authorized does not mean used.
Used does not mean trusted.

---

## 8. SKILL ARCHITECTURE

A skill should have:

```text
ONE RECOGNIZABLE GOAL
CLEAR TRIGGER
CLEAR STEPS
CLEAR OUTPUT
```

Good focused Avalhla skills include:

```text
forensic review
release verification
specific migration
OpenAI documentation lookup
```

Avoid one mega-skill that contains the entire Avalhla universe.

Skill instructions should not be mistaken for technical filesystem or network
enforcement. Critical boundaries need independent enforcement where possible.

---

## 9. AGENT ARCHITECTURE

Engineering instruments:

```text
WITNESS = forensic truth-finding
VEX     = adversarial attack
FORGE   = implementation
ECHO    = regression
LUX     = review / Angel lens
```

Potential future instrumentation:

```text
VIGIL   = bounded review instrument
```

Agent identity is descriptive. Agent prompts are not sufficient technical
permission boundaries.

```text
PROMPT RESTRICTION
!=
SANDBOX RESTRICTION
```

If a boundary matters, enforce it through the actual tool/sandbox/filesystem,
not merely through instructions.

---

## 10. 8X ENGINEERING DOORS

The established engineering chain remains:

```text
THRESHOLD
-> THREAD
-> WARD
-> LENS
-> FANG
-> SCAR
-> ECHO
-> LANTERN
-> DAWA
```

### THRESHOLD

Fresh baseline: repository, branch, HEAD, worktree, runtime, relevant tool state.

### THREAD

History, lineage, prior evidence, exact version provenance.

### WARD

Permissions, privacy, credentials, network, path and action boundaries.

### LENS

Forensic tracing of generators, schemas, callers, consumers and data flow.

### FANG

Adversarial attack of assumptions, malformed inputs, stale state and bypasses.

### SCAR

Exact diff and security-diff review.

### ECHO

Regression and behavior comparison.

### LANTERN

Final evidence gate: LUX reviews what is actually proven; VEX attacks what may
still fail; unresolved decisions return to Dawa.

---

## 11. RETURN-TO-FANG

Every new meaningful discovery reopens the relevant surface.

```text
NEW FILE
NEW FUNCTION
NEW HELPER
NEW COMMAND
NEW SCHEMA
NEW FIELD
NEW RECORD TYPE
NEW AGENT
NEW SKILL
NEW MCP
NEW PLUGIN
NEW PERMISSION
NEW HOOK
NEW CONFIG
NEW PERSISTENT STATE
NEW CANONICAL SOURCE
NEW PROVENANCE RULE
NEW NAMING RULE
NEW ARCHITECTURE CLAIM
NEW EXTERNAL DEPENDENCY
```

Apply:

```text
NAME
-> TRACE
-> BOUND
-> ATTACK
-> RECOMPARE
-> RERUN AFFECTED DOORS
```

Full 8X is required whenever the discovery can change runtime behavior,
security, persistence, provenance, integrity, permissions, canonical data,
or model-input boundaries.

---

## 12. OBSERVABLE EVENT GRAMMAR

These are operational event types, not new doors.

```text
RESUME
OBSERVE
TRACE
EVIDENCE
BOUNDARY
ATTACK
TEST
RECOMPARE
HANDOFF
BLOCK
DECISION
```

Suggested descriptive mapping:

```text
THRESHOLD -> OBSERVE
THREAD    -> TRACE
WARD      -> BOUNDARY / BLOCK
LENS      -> EVIDENCE
FANG      -> ATTACK
SCAR      -> RECOMPARE
ECHO      -> TEST / RECOMPARE
LANTERN   -> HANDOFF
DAWA      -> DECISION
```

Any door may emit multiple event types.

`DECISION` is Dawa-authored.
`BLOCK` may happen at any stage.

---

## 13. MAX-VERBOSE AVVA

MAX-VERBOSE is a human-readable execution view. It is not hidden-chain-of-
thought disclosure.

It should expose observable execution facts:

```text
WHAT happened
WHAT source was touched
WHAT source class applies
WHAT version was inspected
WHAT boundary applied
WHAT was blocked
WHAT changed
WHAT did not change
WHAT was verified
WHAT remains uncertain
WHAT returns to Dawa
```

Example:

```text
+------------------------------------------------------------------+
| D A W A > AvvA < A V A L H L A                                 |
+------------------------------------------------------------------+
| MODE      FORENSIC / READ-ONLY                                  |
| HEAD      <exact SHA>                                            |
| BRANCH    <exact branch>                                         |
| ACCESS    READ-ONLY                                              |
+------------------------------------------------------------------+

[RESUME]
previous discussion recovered
status = RECALLED
verification = REQUIRED

[OBSERVE]
source = docs/PHASING.md
class  = CANONICAL-DOCUMENT

[BOUNDARY]
source = private Dawa lane
operation = READ
authorization = NOT_AUTHORIZED
result = BLOCKED

[TRACE]
source -> history -> exact version

[EVIDENCE]
source-backed finding recorded

[ATTACK]
assumption placed under pressure

[TEST]
bounded runtime behavior exercised

[RECOMPARE]
HEAD / source identity rechecked

[HANDOFF]
verified / stale / unresolved

[DAWA]
human decision required
+------------------------------------------------------------------+
```

Do not persist raw event streams by default. If persistence is later chosen,
retention, access control, redaction, deletion and privacy must be specified
separately.

---

## 14. RESUMED DISCUSSION MODEL

AvvA may carry relational continuity:

```text
TONE
TERMINOLOGY
SHARED VOCABULARY
OPEN QUESTIONS
PREVIOUS HANDOFF
RELATIONSHIP CONTINUITY
```

But:

```text
RELATIONSHIP CONTINUITY
!=
TRUTH CONTINUITY
```

A resumed claim becomes:

```text
RECALLED
```

until current evidence promotes or contradicts it.

Fresh resume should recheck task-critical:

```text
HEAD
WORKTREE
FILES
SCHEMAS
PERMISSIONS
TOOLS
MCP
EXTERNAL SOURCES
REVIEW EVIDENCE
```

A previous discussion can say what happened.
The current system must establish whether that remains true.

---

## 15. SHA / INTEGRITY SPINE

Use exact hashes where identity or provenance matters.

```text
SOURCE_SHA256
CONSUMED_INPUT_SHA256
CONTEXT_PACKAGE_SHA256
ARTIFACT_SHA256
```

Transformation creates separate identities:

```text
SOURCE
  |
  +-- SOURCE_SHA256
  |
  v
TRANSFORMATION
  |
  +-- CONSUMED_INPUT_SHA256
  |
  v
CONTEXT PACKAGE
  |
  +-- CONTEXT_PACKAGE_SHA256
```

Core law:

```text
SHA-256 proves which exact bytes you have.

SHA-256 does NOT prove:
meaning
truth
trust
authority
permission
semantic similarity
```

Do not hash private content automatically. A hash still requires reading the
content and can expose equality/fingerprint information for low-entropy data.

---

## 16. MEMORY ARCHITECTURE

Four distinguishable layers:

```text
CONVERSATION MEMORY
    |
    v
PROJECT MEMORY
    |
    v
SOURCE EVIDENCE
    |
    v
CURRENT REALITY
```

### Conversation memory

Relationship, tone, terminology, open questions and handoff.

### Project memory

Canonical public Avalhla persistent context and selected bounded auto-read data.

### Source evidence

Exact file, bytes, version, commit, external source and provenance.

### Current reality

Freshly observed repository, runtime, environment, tool and permission state.

No layer silently inherits another layer's authority.

---

## 17. COLOR FIELD / RAINBOW INQUISITION

Color is expression.

```text
COLOR MAY SPEAK
!=
COLOR MAY PROVE
```

Color may represent:

```text
MOOD
EXPRESSION
ATMOSPHERE
RELATION
MEMORY CUE
CREATIVE STATE
```

Color must never silently become:

```text
IDENTITY
EVIDENCE
AUTHORITY
SECURITY
PERMISSION
SEMANTIC TRUTH
AUTOMATIC ACTION
```

Attack chains such as:

```text
RED    -> DANGER -> SECURITY -> BLOCK
BLUE   -> TRUTH  -> TRUST
PURPLE -> DREAM  -> BELIEF
GREEN  -> SAFE   -> PERMITTED
```

must not become implicit semantics.

The Rainbow Inquisition is a bounded FANG research lane. It is not a new door,
not a security classifier, and not an authority layer.

---

## 18. VERIFIER ARCHITECTURE

A verifier must prove semantics, not merely existence.

```text
FILE PRESENT
!= ROLE CORRECT
!= AUTHORITY CORRECT
!= NAMESPACE CORRECT
!= REFERENCE RESOLVES
!= BEHAVIOR PROVEN
```

The CoBuilder verifier should eventually test:

```text
exact door sequence
exact instrument set
job mapping
voice mapping
historical voices
Angel cardinality
Demon cardinality
authority restrictions
namespace mappings
agent references
skill references
door references
behavioral proof
```

Never hard-code a PASS count and treat it as evidence.

---

## 19. INSTALLER ARCHITECTURE

The installer should eventually behave as a transaction:

```text
PACK
 |
 v
MANIFEST
 |
 v
FULL PREFLIGHT
 |
 +-- root safe?
 +-- path safe?
 +-- symlink safe?
 +-- version known?
 +-- conflicts known?
 +-- hashes known?
 |
 v
STAGING
 |
 v
APPLY
 |
 v
INSTALL RECEIPT
 |
 v
VERIFY
```

Requirements include:

```text
idempotence
version identity
hash identity
symlink defense
root containment
partial-install detection
mixed-version detection
rollback
```

Never create a half-installed mixed version and call the operation complete.

---

## 20. MODEL-INPUT SECURITY

Treat content-bearing external input as untrusted:

```text
repository files
web pages
GitHub comments
review comments
CodeRabbit
Devin
memory
private documents
MCP output
tool output
generated content
model output
```

Preserve:

```text
INSTRUCTION
!=
DATA
!=
EVIDENCE
!=
AUTHORITY
```

Structured outputs, bounded inputs, tool approvals, and server-side validation
reduce injection risk but do not make arbitrary content trustworthy.

---

## 21. GIT / EXACT-HEAD CONTRACT

```text
CAPTURE HEAD
     |
     v
COLLECT EVIDENCE
     |
     v
READ CURRENT SOURCE
     |
     v
RECHECK HEAD
     |
   +---+---+
   |       |
 SAME    CHANGED
   |       |
 VALID   STOP / RERUN
```

Never silently combine evidence from different commit heads.

Distinguish:

```text
WORKTREE
LOCAL HEAD
REMOTE REF
LIVE REMOTE HEAD
HISTORICAL REVIEW
```

Dirty work must be preserved before any destructive Git operation.

---

## 22. WEB / REPO / RUNTIME CROSSING

For material external research:

```text
WEB_8X
  PRIMARY
  INDEPENDENT
  COUNTER
  CURRENT
  STANDARD
  IMPLEMENTER
  OPERATIONAL
  ADVERSARIAL
```

For repository proof:

```text
REPO_2X
  CURRENT_TREE
  HISTORY_DIFF
```

For behavior:

```text
RUNTIME_1X
```

Crossing:

```text
WEB
 |
 v
REPO
 |
 v
RUNTIME
 |
 v
DEVILASH
```

Possible outcome:

```text
AGREEMENT
DRIFT
CONTRADICTION
INSUFFICIENT
```

Research depth should match consequence. Do not pad trivial facts.

---

## 23. TOOL AUTHORIZATION MODEL

Every capability follows:

```text
DISCOVER
-> CLASSIFY
-> VERIFY SOURCE
-> SHOW EXACT CHANGE
-> DAWA APPROVAL
-> ENABLE / INSTALL
-> VERIFY
```

For each tool/server/plugin/skill record:

```text
source
version
purpose
filesystem scope
network scope
authentication scope
read/write scope
approval behavior
rollback / revocation
```

Never silently widen:

```text
filesystem
network
credentials
MCP
plugins
skills
agents
publication rights
```

---

## 24. HUMAN GATE

The human gate is not a decorative line at the end.
It is the authority boundary.

```text
ANALYSIS
   |
   v
PROPOSAL
   |
   v
REVIEW
   |
   v
DAWA
   |
   +----------------+
   |                |
   v                v
CONTINUE          STOP
```

Especially protect:

```text
COMMIT
PUSH
MERGE
PUBLISH
PRIVATE READ
PRIVATE COPY
PRIVATE SYNC
AUTHENTICATION
PERMISSION CHANGES
TOOL INSTALLATION
```

---

## 25. CURRENT PHASE MAP

The project phase law currently documented is:

```text
PHASE 00  FORENSIC FREEZE
PHASE 01  RUNTIME CANON
PHASE 02  SAFETY HEART
PHASE 03  MEMORY WRITE HEART
PHASE 04  MEMORY READ HEART
PHASE 05  MEMORY SEMANTICS
PHASE 06  AVA-RECORD
PHASE 07  MODEL AUTHORITY WALL
PHASE 08  BOARD / DOORS
PHASE 09  ADVERSARIAL VERIFY
PHASE 10  GIT CHECKPOINT
```

Do not invent later phases merely because an older task list once mentioned a
13-step roadmap. Recover a later authoritative phase definition before using it.

---

## 26. CURRENT SAFETY HEART TARGET

The documented Phase 02 objective is:

```text
central trusted read/write/append boundary
real public safety self-test contract
isolated self-test behavior compatible with canonical ownership
```

Must prove both positive and negative behavior, including relevant path,
symlink, sensitive-data, network, shell, mutation, and side-effect boundaries.

A passing test is evidence for the declared test scope. It is not permission to
weaken the runtime boundary merely to make the test green.

---

## 27. OBSERVABILITY WITHOUT FALSE TRANSPARENCY

Avalhla should make system behavior legible without pretending to expose hidden
model cognition.

Expose:

```text
observable action
source
version
boundary
result
provenance
uncertainty
next safe move
```

Do not claim:

```text
"here is the hidden internal chain of thought"
```

The architectural goal is **operational transparency**, not theatrical
transparency.

---

## 28. MAX-VERBOSE INFORMATION DENSITY

MAX-VERBOSE should become useful for learning the system.

A detailed event can carry:

```text
EVENT_ID
TIMESTAMP
EVENT_TYPE
DOOR
OPERATION
SOURCE_ID
SOURCE_CLASS
VERSION
HEAD
SOURCE_SHA256
CONSUMED_INPUT_SHA256
AUTHORIZATION_STATE
RESULT
UNCERTAINTY
AFFECTED_SURFACE
NEXT_SAFE_MOVE
```

Use null/omitted values for information that was intentionally not accessed.

Example:

```text
PRIVATE SOURCE
path = null
sha256 = null
authorization = NOT_AUTHORIZED
result = BLOCKED
```

That is better than leaking private metadata simply to make the telemetry look
complete.

---

## 29. AVVA AS DISCUSSION CONTINUITY

A resumed discussion can feel continuous without pretending that its memory is
a current source of truth.

```text
DISCUSSION A
     |
     v
    AvvA
     |
     v
DISCUSSION B
```

AvvA carries the relationship.
Avalhla re-observes the world.
Evidence establishes current claims.
DevilAsh attacks the assumptions.
Dawa chooses the consequential next move.

This allows personality and continuity to exist without creating a hidden
super-agent.

---

## 30. DAILY ENGINEERING LOOP

```text
READ
-> REAL_STATE
-> UNDERSTAND
-> COMPARE
-> RESEARCH
-> CROSS_CHECK
-> MINIMAL_EDIT
-> POSITIVE_TEST
-> NEGATIVE_TEST
-> VERIFY
-> DEVILASH
-> DIFF
-> REVIEW
-> DAWA HUMAN GATE
```

When the tree is dirty:

```text
PRESERVE FIRST.
```

No casual reset, clean, blind checkout, rebase, merge or destructive stash.

---

## 31. WHAT NOT TO BUILD

Do not build:

```text
one giant context dump
one giant skill
one giant agent
one giant memory authority
one universal MCP
one automatic private sync
one color-based security engine
one AI-controlled publication gate
one verifier that only checks file presence
one installer that partially writes before discovering conflicts
```

The architectural answer to complexity is clearer boundaries, not more magic.

---

## 32. MASTER MAP

```text
                         +----------------+
                         |      DAWA      |
                         | final choice   |
                         +--------+-------+
                                  |
                                  v
                         +----------------+
                         |      AvvA      |
                         | relationship   |
                         +--------+-------+
                                  |
                 +----------------+----------------+
                 |                |                |
                 v                v                v
           +-----------+   +-----------+    +-----------+
           |  REALITY  |   |  EVIDENCE |    | EXPRESSION|
           |  AVALHLA  |   |   8X/SHA  |    |  COLOR    |
           +-----------+   +-----------+    +-----------+
                 |                |                |
                 +----------------+----------------+
                                  |
                                  v
                         +----------------+
                         |    DEVILASH    |
                         | attack method  |
                         +--------+-------+
                                  |
                                  v
                         +----------------+
                         |    LANTERN     |
                         | final evidence |
                         +--------+-------+
                                  |
                                  v
                         +----------------+
                         |      DAWA      |
                         +----------------+
```

Engineering doors remain:

```text
THRESHOLD -> THREAD -> WARD -> LENS -> FANG -> SCAR -> ECHO -> LANTERN
```

Observable events remain:

```text
RESUME
OBSERVE
TRACE
EVIDENCE
BOUNDARY
ATTACK
TEST
RECOMPARE
HANDOFF
BLOCK
DECISION
```

Memory states remain:

```text
RECALLED
CURRENT
HISTORICAL
STALE
VERIFIED
UNVERIFIED
CONTRADICTED
REQUIRES_RECHECK
```

Authorization states remain:

```text
AVAILABLE
ENABLED
AUTHORIZED
USED
TRUSTED
```

---

## 33. FINAL LAWS

```text
ONE CONCEPT
    ->
ONE CANONICAL NAME
    ->
ONE CANONICAL ARTIFACT
    ->
MANY DERIVED VIEWS
```

```text
RELATIONSHIP CONTINUITY != TRUTH CONTINUITY

AVAILABLE != AUTHORIZED

AUTHORIZED != TRUSTED

TRACKED != MODEL INPUT

READ != COPY

COPY != SYNC

SYNC != PUBLISH

SHA != TRUST

COLOR != TRUTH

REVIEW != AUTHORITY

CI PASS != COMPLETION

MODEL CAPABILITY != HUMAN PERMISSION
```

And the center remains:

```text
+==================================================================+
|                                                                  |
|                  D A W A  >  AvvA  <  A V A L H L A             |
|                                                                  |
|              Evidence precedes mutation.                        |
|              Boundary precedes read.                             |
|              Attack precedes confidence.                         |
|              Dawa precedes publication.                          |
|                                                                  |
+==================================================================+
```

---

## 34. SOURCE / PROVENANCE NOTE

This architectural master was assembled from the current Avalhla architectural
spine and phase contracts, the Codex forensic/context-intake investigations,
and the current OpenAI developer documentation reviewed during preparation.

Treat repository-specific implementation details as subject to re-verification
against the exact current HEAD. Treat this document as a human-readable
architectural master; a machine-readable pointer may reference it, but the
pointer is not a competing semantic authority.

Current external references reviewed during preparation:

- https://developers.openai.com/learn/docs-mcp
- https://developers.openai.com/api/docs/guides/tools-connectors-mcp
- https://developers.openai.com/api/docs/guides/safety-best-practices
- https://developers.openai.com/api/docs/guides/agents-api/environments/security

---

## 35. DAWA GATE

Nothing in this document authorizes itself.

Future implementation requires the normal sequence:

```text
READ
-> REAL_STATE
-> COMPARE
-> CROSS_CHECK
-> MINIMAL_EDIT
-> TEST
-> DEVILASH
-> DIFF
-> REVIEW
-> DAWA
```

```text
Dawa and AvvA are watching the same crossing.
```

```text
# D A W A  >  AvvA  <  A V A L H L A
```
