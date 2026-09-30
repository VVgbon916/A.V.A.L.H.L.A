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
