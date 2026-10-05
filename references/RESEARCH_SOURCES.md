# Research sources checked 2026-09-28

- OpenAI Build Skills — current skill structure, name/description metadata, and progressive loading:
  https://learn.chatgpt.com/docs/build-skills
- OpenAI Codex configuration reference — project config, profiles, `[agents]`, custom agent `config_file`, sandbox and feature settings:
  https://learn.chatgpt.com/docs/config-file/config-reference
- OpenAI Codex Subagents — custom agent files, name/description/developer_instructions, model/reasoning and permission inheritance:
  https://learn.chatgpt.com/docs/agent-configuration/subagents
- OpenAI Docs MCP — official read-only developer documentation server and the recommended AGENTS.md usage:
  https://developers.openai.com/learn/docs-mcp
- Codex Security scan — standard scan workflow and evidence coverage:
  https://learn.chatgpt.com/docs/security/plugin/scans
- Codex Security deep scan — standard vs deep scan and explicit note that deep scans do not replace diff-focused review:
  https://learn.chatgpt.com/docs/security/plugin/deep-scans
- GitHub MCP server configuration — toolset allow-lists, read-only mode, lockdown mode, and their security semantics:
  https://github.com/github/github-mcp-server/blob/main/docs/server-configuration.md
- GitHub MCP server README — read-only usage and tool configuration:
  https://github.com/github/github-mcp-server
- OpenAI multi-agent guidance — use subagents for independent tasks; dependent short tasks belong in the main agent; agents editing the same files must coordinate:
  https://developers.openai.com/api/docs/guides/agents-api/multi-agent

## Naming conclusion derived from the attack

The most stable naming relationship is:

DOOR → JOB → INSTRUMENT → VOICE → TOOL BOUNDARY

This avoids making job names look like personas and avoids making historical or adversarial voices into authorities.

## Indexing and retrieval design candidates

English public-safe synthesis of the supplied 2026-09-29 indexing research.
This section is research, not an implemented retrieval contract, a second
CoBuilder master, or a current verification of third-party product behavior.
The attachment's references are leads to recheck before implementation.

```text
INDEX != SOURCE
SUMMARY != SOURCE
RETRIEVAL != TRUTH
QUERY VIEW != CANONICAL MEANING
RELATIONSHIP CONTINUITY != TRUTH CONTINUITY
```

### Structure first / many bounded views

Keep the canonical source or raw record as the lossless fallback. Explore
structural trees, symbolic relations, and optional lexical/vector candidate
search as separate derived views. Deterministic structure should precede model
refinement where available. A relevance score is not evidence of truth.

For conversations, a derived topic tree could offer summaries at different
depths while retaining exact message ranges and source versions. For a
contradictory or high-consequence question, consider a bounded sibling or
second-path check rather than trusting one attractive branch.

Candidate provenance fields include source identity, version, range, SHA-256,
derivation, generation time, and freshness classification. These are not
additions to the current schema. An unchanged record digest cannot establish
freshness if its source changed.

### Derived ownership / skill evaluation

Generated summaries, concept pages, entity pages, and cross-document syntheses
must be labeled as derived. A rebuild must not silently overwrite human-owned
canonical artifacts. Explicit ownership and recoverable source references
matter more than the choice of indexing product.

A proposed generated skill should have a bounded trigger and be checked with
both should-trigger and should-not-trigger cases before a separate enablement
decision. Generation, discovery, and invocation do not grant permission.

```text
PERSONA -> ABILITY -> SKILL -> ACTION -> TOOL -> OBJECT -> RECORD -> MEMORY

ABILITY != AUTHORITY
SKILL TRIGGER != PERMISSION
GENERATED SKILL != CANONICAL SKILL
OBJECT != TRUTH
OBJECT != MEMORY
```

This vocabulary is descriptive research, not a new runtime schema or identity
assignment. Existing names remain owned by their canonical documents.

### Review design questions

Investigate separation between reviewed content, trusted review configuration,
and aggregation. Keep context expansion bounded, ground findings in exact
source, and discard affected evidence when the candidate changes. Static tools
can provide a separate witness; model agreement is not a substitute for them.
Descriptive tool annotations must not be mistaken for enforced permissions.

Before adopting an indexing implementation, challenge whether:

- A summary can outrank or overwrite its source.
- A stale index can claim to be current.
- One branch can hide contradictory evidence.
- A generated skill can self-enable or acquire privileges.
- Retrieval can exceed its context budget or expose private material.
- A derived result can write memory without the owning write boundary.
- Same names in different namespaces can silently merge meanings.

### Historical research leads / not reverified here

- [PageIndex](https://github.com/VectifyAI/PageIndex)
- [PageIndex Flash](https://pageindex.ai/blog/pageindex-flash)
- [PageIndex File System](https://pageindex.ai/blog/pageindex-filesystem)
- [PageIndex document search](https://docs.pageindex.ai/tutorials/doc-search)
- [ChatIndex](https://github.com/VectifyAI/ChatIndex)
- [OpenKB](https://github.com/VectifyAI/OpenKB)
- [OpenKB skill examples](https://github.com/VectifyAI/OpenKB/tree/main/examples/skills)
- [PR-AF](https://github.com/Agent-Field/pr-af)
- [Agentic Code Reviewer](https://github.com/richhaase/agentic-code-reviewer)
- [Open-source review survey](https://www.augmentcode.com/tools/open-source-ai-code-review-tools-worth-trying)
- [MCP tool-annotation discussion](https://blog.modelcontextprotocol.io/posts/2026-03-16-tool-annotations/)

Provider-specific guidance in the original research is not reasserted here.
Consult current official documentation before changing provider integration.
No dependency, service, index, schema, or generated skill is enabled by this
research section.
