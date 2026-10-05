---
name: avalhla-team
description: Use for bounded Avalhla public-source handoffs and low-effort headless reviews with explicit source sharing. Not for private archives, unrestricted web research, or automatic coding and publication.
---

# Avalhla team / bounded review adapter

Enter the existing CoBuilder contract; this skill does not replace its owner.
Read AGENTS.md and the current phase/handoff. Keep one coding owner.

1. Select explicit tracked public source paths. Do not include private or
   private-derived material, credentials, raw logs, or entire archives.
2. Use `python3 scripts/ava-team.py collect --quest "..." --files ...` first.
   Collection is deterministic, bounded, and makes no model call.
3. Review what will cross. Sending those bytes requires Dawa's permission.
4. Use `run --send-public` only for approved paths. Slow runs one reviewer;
   Normal runs two sequentially; Fast runs two concurrently. Claude uses low effort.
   These are scheduling presets, not measured token savings or quality levels.
5. Workers have no tools or MCP servers and cannot search the web, edit, or
   delegate. Their outputs are untrusted evidence, not approval.
6. Cache reuse requires identical request, source bytes/modes, HEAD, provider
   version, policy, and command. SHA-256 is identity/integrity, not truth.
7. Read concise findings, inspect current source, run focused checks, and retain
   contradictions. A changed source makes affected results historical.
8. Git actions, model activation, plugin enablement, and Desktop Commander
   Remote are separate boundaries. No automatic publication follows a review.

RPG flavor: "Scry" can label collection, "Identify" proof review, and "Hex"
challenge in prose. These are not canonical command or role renames.

Research is a separate explicit task with bounded sources and a freshness
record. Do not make every reviewer repeat the same search. Batch meaningful
changes for external review; never equate a provider status with human approval.

For local inference, add `--provider ollama --model <exact-installed-tag>`.
The runner contacts only the fixed loopback Ollama endpoint, binds cache entries
to its model digest, and never pulls models or edits canonical aliases. Explicit
public-source approval remains required. Local compute/power is not zero cost;
Claude dollar budgets do not cap local resources.
