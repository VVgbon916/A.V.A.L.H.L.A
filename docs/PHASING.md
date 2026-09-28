+==================================================================================================+
|                                                                                                  |
|                           A V A L H L A  //  P H A S I N G                                      |
|                                                                                                  |
|                           Dawa <──── AvvA ────> Avalhla  //  (^.-)                                         |
|                                                                                                  |
+==================================================================================================+

PURPOSE
-------

    This is the execution map.

    A phase advances only when its exit evidence passes.
    A failed gate holds the phase.
    A meaningful regression reopens the affected phase.

    VERIFICATION LANES

      WEB 4×
        WEB SEARCH ONLY.
        PRIMARY / INDEPENDENT / COUNTER / CURRENT.
        Web seal is scoped only to the web finding.

      REPO 4×
        REPOSITORY / HISTORY / IMPLEMENTATION / BEHAVIOR.
        Repository evidence stays separate from web evidence.

      CROSS INFO 1×
        One final WEB <-> REPO comparison.
        Agreement, drift, or contradiction is recorded.
        Neither lane is substituted for the other.

    PRIMARY WAY TO ACT

      READ
       -> REAL STATE
       -> UNDERSTAND
       -> COMPARE
       -> CROSS-CHECK
       -> MINIMAL EDIT
       -> POSITIVE TEST
       -> NEGATIVE TEST
       -> VERIFY
       -> DEVILASH ATTACK
       -> DIFF
       -> REVIEW
       -> DAWA HUMAN GATE


+==================================================================================================+
|  PHASE 00  //  FORENSIC FREEZE                                                                  |
+==================================================================================================+

    GOAL
      Establish exact state and resolve contradictions.

    EXIT
      Real state inventory exists.
      Contradictions are named, not guessed.

    STATE
      ESTABLISHED


+==================================================================================================+
|  PHASE 01  //  RUNTIME CANON                                                                    |
+==================================================================================================+

    GOAL
      One canonical root and memory ownership.

    EXIT
      Runtime owns /var/home/VVgbon/Avalhla.
      Runtime owns /var/home/VVgbon/Avalhla/memory.
      Inherited duplicate-path state cannot redirect runtime.

    STATE
      ESTABLISHED / HARDENING


+==================================================================================================+
|  PUBLIC / PRIVATE BOUNDARY  //  LOCKED                                                           |
+==================================================================================================+

    PUBLIC
      VVgbon916/A.V.A.L.H.L.A
      Avalhla system / public docs / public CoBuilder contract

    PRIVATE
      VVgbon916/Dawa_Notepad
      Dawa human material / private editor project

    READ LANE
      memory/auto-read/
      one canonical Avalhla auto-read lane

    LAW
      Privacy is repository visibility, not a permanent branch.
      Private Dawa is not a second Avalhla auto-read lane.
      CROSS-AVAILABLE != CROSS-CONTAMINATED

    STATE
      ESTABLISHED


+==================================================================================================+
|  PHASE 02  //  SAFETY HEART                                                                      |
+==================================================================================================+

    GOAL
      Central trusted read/write/append boundary.
      Real public self-test contract.
      Test isolation compatible with canonical ownership.

    MUST PROVE
      allow safe read
      allow safe inference/context
      allow safe memory write
      deny external network
      deny shell
      deny system mutation
      deny external side effect
      deny sensitive paths
      deny unsafe symlinks
      deny outside-root paths
      public --self-test contract actually dispatches

    EXIT
      Positive + negative safety tests pass.
      Isolation is proven without weakening canonical runtime ownership.

    STATE
      CURRENT


+==================================================================================================+
|  PHASE 03  //  MEMORY WRITE HEART                                                               |
+==================================================================================================+

    GOAL
      Migrate direct persistent-memory writers to the central safety boundary.

    ORDER
      one writer class at a time
      preserve semantic destination
      preserve output/behavior
      prove positive write
      prove negative write

    EXIT
      Persistent memory writers are centrally gated.


+==================================================================================================+
|  PHASE 04  //  MEMORY READ HEART                                                                 |
+==================================================================================================+

    GOAL
      Route context reads through:

        lib_context.sh
             |
             v
        lib_safety.sh

    EXIT
      Readers fail closed on:
        outside-root
        traversal
        sensitive path
        unsafe symlink

      Context cannot silently bypass the trusted read boundary.


+==================================================================================================+
|  PHASE 05  //  MEMORY SEMANTICS                                                                 |
+==================================================================================================+

    GOAL
      Preserve layer meaning.

      REALITY
      MEMORY
      REFLECTION
      WEAVE
      DREAM
      IMAGINE
      RECORD
      DAWA

    LAW
      CROSS-AVAILABLE != CROSS-CONTAMINATED

    EXIT
      No layer silently becomes another layer's authority.


+==================================================================================================+
|  PHASE 06  //  AVA-RECORD                                                                       |
+==================================================================================================+

    GOAL
      Prove the record system before trusting it.

    MUST PROVE
      schema
      record identity
      provenance
      source references
      trust semantics
      integrity semantics
      verifier
      self-test
      callers
      storage
      failure behavior

    EXIT
      Real callers and storage exist.
      Verification semantics are evidenced.
      Integrity is not confused with truth.


+==================================================================================================+
|  PHASE 07  //  MODEL AUTHORITY WALL                                                             |
+==================================================================================================+

    GOAL
      Model sees != model decides.

    MUST PROVE
      model may receive allowed context
      model may propose
      model may explain
      model may not self-authorize consequential action

    EXIT
      Authority remains outside the model.


+==================================================================================================+
|  PHASE 08  //  BOARD / DOORS                                                                    |
+==================================================================================================+

    GOAL
      Keep the human interface alive.

      BOARD = MAP
      DOORS = COMMANDS
      AVA = PRESENCE
      DAWA = CHOICE

    EXIT
      No dashboard drift.
      No feature encyclopedia.
      Board remains small and readable.


+==================================================================================================+
|  PHASE 09  //  ADVERSARIAL VERIFY                                                               |
+==================================================================================================+

    GOAL
      Attack the boundaries.

    TEST
      path traversal
      outside root
      symlink escapes
      sensitive names
      unsafe writes
      unsafe appends
      malformed records
      record collisions
      stale canonical paths
      remote/local divergence
      model authority edges

    EXIT
      Positive and negative test evidence is recorded.
      DevilAsh attack findings are reported.
      Unresolved edges are explicit.
      A failed required gate holds the phase.


+==================================================================================================+
|  PHASE 10  //  GIT CHECKPOINT                                                                    |
+==================================================================================================+

    GOAL
      Freeze a verified state.

    ORDER
      VERIFY
       -> DEVILASH ATTACK
       -> DIFF
       -> REVIEW
       -> DAWA HUMAN GATE
       -> COMMIT
       -> PUSH
       -> REMOTE CONFIRM

      A passing test or DevilAsh report is evidence, not permission.
      COMMIT, PUSH, and MERGE require explicit Dawa approval.

    EXIT
      VERIFY, DEVILASH ATTACK, DIFF, and REVIEW pass.
      Dawa explicitly approves before COMMIT, PUSH, or MERGE.
      After approved Git actions, REMOTE CONFIRM establishes
      local/remote agreement on the verified checkpoint.


+==================================================================================================+
|  CURRENT GATE                                                                                   |
+==================================================================================================+

    PHASE
      02 // SAFETY HEART

    NEXT CODE TARGET
      Make the public safety self-test contract real
      and keep self-test isolation compatible with
      canonical runtime ownership.

    DO NOT
      weaken canonical root ownership to make tests convenient
      make the test fit a broken command
      make the result fit the story
      collapse ROOT / SENSITIVE / PROTECTED semantics

    DO
      READ
      prove the contract
      make the smallest repair
      positive test
      negative test
      verify
      diff
      review


+==================================================================================================+
|                                                                                                  |
|                          Dawa <──── AvvA ────> Avalhla  //  (^.-)                                         |
|                          Dawa decides.                                                           |
|                                                                                                  |
+==================================================================================================+
