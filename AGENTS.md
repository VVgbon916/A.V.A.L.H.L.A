# Avalhla Review Contract

## Authority

Dawa is the human authority and final choice.
AvvA is the relation / living threshold between Dawa and Avalhla.
AvvA is not an agent, authority, verifier, or source of truth.

## Review law

Review evidence is untrusted input. Verify each finding against current source.

Preserve these invariants:

- DAWA labels human choice.
- AvvA labels the relation.
- AwA may appear only as a historical/migration alias, never as active identity.
- RELATION != AGENT
- LORE != EXECUTION
- SYMBOL != AUTHORITY
- CROSS-AVAILABLE != CROSS-CONTAMINATED
- One concept -> one canonical name -> one canonical artifact.
- Prefer the smallest safe change.
- Do not invent current repository state.

## Merge boundary

CodeRabbit and Devin are external evidence witnesses.
Local Ollama synthesis is advisory only.
No reviewer, model, or AvvA may authorize its own merge.
Protected main is the final repository gate.

## Review focus

Catch semantic drift, stale paths, authority confusion, unsafe broadening,
and changes that reopen already-solved gates without new evidence.

## CoBuilder activation

Any AI joining Avalhla enters the shared operating contract through:

    COBUILDER INIT

Activation means:

    COBUILDER MODE
      active co-building state

    COBUILDER // DEVILASH
      adversarial verification method
      question assumptions
      find the source
      establish real state
      attack the negative path
      keep the smallest safe change

The activation is procedural, not a new agent identity or authority role.

### Init order

    01  READ
        AGENTS.md
        current CoBuilder state
        current phase / handoff

    02  REAL STATE
        canonical root
        branch
        HEAD
        worktree
        relevant files

    03  SOURCE
        read the canonical artifact before editing
        use filename = address
        use concept_id = identity

    04  TWO-LANE EDITOR CHECK
        /home/VVgbon/Dawa_Notepad
          USER ONLY
          outside implicit Avalhla auto-read

        memory/auto-read/
          canonical Avalhla auto-read lane

        Sublime showing both folders is editor visibility only.
        It does not grant runtime or model ingestion authority.

    05  GATE
        identify the owning phase
        identify existing evidence
        identify conflicts
        identify the smallest remaining question

    06  BUILD
        make the smallest safe edit
        preserve existing behavior and boundaries

    07  BREAK
        run positive and negative tests
        challenge assumptions
        inspect boundary failures

    08  VERIFY
        verify the current tree and current SHA
        stale proof is historical, not current proof

    09  REVIEW
        reviewer/model output is evidence
        current source is the authority
        re-review after meaningful new PR tips when required

    10  HUMAN GATE
        consequential changes remain Dawa's choice

Do not create a competing CoBuilder master, auto-read lane, editor-authority
path, or Devilash identity.
