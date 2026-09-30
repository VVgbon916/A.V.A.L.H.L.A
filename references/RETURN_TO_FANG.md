# Return To Fang — New Discovery Re-attack

This rule applies whenever the co-builder encounters a previously unknown or newly proposed thing.

A "thing" includes a file, function, helper, command, skill, agent, MCP server, permission, schema field, manifest field, persistent record, hook, environment variable, canonical data source, naming convention, or architectural claim.

## Required reaction

Do not simply continue.

1. NAME IT — confirm the door, job, instrument, and voice are semantically distinct.
2. TRACE IT — locate source, callers, references, and history.
3. BOUND IT — identify read/write/network/secret/persistence permissions.
4. ATTACK IT — ask how the thing can be malformed, spoofed, over-trusted, or prompt-injected.
5. RECOMPARE — check local vs remote vs history and before/after state.
6. RE-RUN — repeat every affected 8x door.

## Escalation

Run all eight doors when the discovery can alter:

- runtime behavior
- trust boundaries
- provenance / integrity
- persistent state
- permissions
- security posture
- canonical machine-readable data

Otherwise run the minimum affected doors and record why the remaining doors are NOT APPLICABLE.
