# Avalhla Voices

## Historical/reference layer

### VALHLA
**Voice of Wisdom.**

Use for historical lineage, prior design decisions, and reference context.

### LHLAVA
**Voice of Anger / finding the solution.**

Use as historical expressive context for urgency, friction, and the push to resolve a problem.

Neither voice is an autonomous agent. Neither is the Angel or Demon.

## Runtime/co-builder layer

### AVALHLA
**Voice of Reality.**

What is actually present now.

### LUX
**Angel.**

Clarity, evidence, care, boundary protection.

LUX is a review lens, not a source of authority.

### VEX
**Demon.**

Doubt, fracture, adversarial pressure, assumption-breaking.

VEX is an attack lens, not a source of authority.

### AvvA
**Co-building relationship.**

The bridge between Dawa's intention and the engineering work.

### DAWA
**Decision.**

The human gate for meaningful writes, commits, pushes, merges, and releases.

## Evidence instruments

The native role files under `.codex/agents/` describe configured workers.
This human explanation neither activates them nor changes their permissions.

| Instrument | Question | Boundary |
|---|---|---|
| WITNESS | What is actually here? | Read-only observation |
| VEX | Can this claim be broken? | Attacks within isolated fixtures/artifacts |
| FORGE | What is the smallest justified repair? | Scoped implementation |
| ECHO | What changed before and after? | Regression evidence |
| LUX | What does the evidence actually prove? | Read-only review |
| DAWA | What do I choose? | Final human choice |

### LUX / proof quality

LUX compares observations, attacks, patches, and regression results without
treating any one report as authoritative. Its native report shape is:

```text
SUPPORTED        claims directly supported by evidence
UNSUPPORTED      claims that exceed that evidence
PROOF GAPS       important properties not yet demonstrated
AFFECTED SURFACE files, callers, and boundaries involved
NEXT SAFE MOVE   recommendation, not permission
```

For example, a matching SHA-256 digest can establish byte equality against an
expected digest. It does not establish meaning, permission, or trust. An object
checking its own digest does not necessarily prove that a referenced source is
still current. These are distinctions to investigate, not assertions of a
current verifier bug.

Similarly, passing tests establish the behaviors exercised by those tests.
They do not prove every untested boundary or authorize a merge.

### VEX / reproducible challenge

VEX looks for malformed inputs, path confusion, stale state, races, provenance
gaps, and authority escalation. Its native report shape is:

```text
ATTACK / EXPECTED / ACTUAL / EVIDENCE
IMPACT / REPRODUCTION / PROOF GAP
```

A successful attack is evidence, not permission to change production.
LUX asks how far that evidence supports a conclusion; VEX challenges the
remaining assumptions. Neither chooses for Dawa.

### Expressive vocabulary

"Angel" and "Demon" are literary lenses for care and adversarial doubt, not
claims of supernatural capability, unlimited access, or security guarantees.
"Healer" can describe recovering a clear bounded handoff; it does not grant
the ability to reset another provider's session or alter its configuration.

VALHLA is not LUX. LHLAVA is not VEX. Historical resonance does not silently
merge identities or assign a new coding role.
