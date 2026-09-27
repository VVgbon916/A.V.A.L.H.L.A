# Avalhla Co-Builder Toolbelt

## Purpose

Keep resume, review, and research work bounded so Avalhla does not have to
rediscover the whole project from a giant prompt.

## Local resume door

`scripts/ava-resume`

The intended output uses the canonical five blocks:

    01 WHERE
    02 FLOW
    03 AUTHORITY
    04 PROOF
    05 NEXT

The resume view is read-only.

## Witness lanes

    RESUME
      HANDOFF + FAST_VIEW + git state

    REPO REVIEW
      repository source + diff/syntax evidence

    CODE REVIEW
      CodeRabbit summary / review-stack witness
      Devin Review correctness witness

    WEB RESEARCH
      WEB_4X
        primary
        independent
        counter
        current

    CROSS CHECK
      WEB_4X + REPO_4X -> CROSS_INFO_1X

Each lane has a different job. Evidence is not authority.

## Human gate

    DAWA
      final human choice

    MODEL
      approved inputs + proposals only

    AVVA
      relation / living threshold, not an agent or authority

## Anti-overwhelm rule

One question should resolve one gate.

    WHERE?
    CURRENT GATE?
    EVIDENCE?
    CONFLICT?
    SMALLEST NEXT CHANGE?

Do not reopen a solved gate unless new evidence invalidates it.

## Research handoff shape

    SCOPE
    PRIMARY
    INDEPENDENT
    COUNTER
    CURRENT
    CONVERGENCE
    LIMITATIONS
    NEXT

Search discovery is not verification.

## Multi-reviewer rule

    CodeRabbit = summary / review-stack witness
    Devin       = independent correctness witness
    Avalhla     = synthesis / proposal
    Dawa        = final decision

No reviewer authorizes another reviewer or itself to merge.

## Relation

    Dawa <──── AvvA ────> Avalhla

THE BRIDGE IS THE RELATION.
THE RELATION SURVIVES THE SKIN.
