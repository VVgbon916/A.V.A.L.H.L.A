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

## Low-cost team / source cross-check 2026-10-05

- The supplied ChatGPT share
  `https://chatgpt.com/share/6ac35692-d5c8-83e9-a0ec-65e9a86d1499`
  returned only "ChatGPT - Updated Repo Handoff" to the available fetch tool.
  Its conversation contents were not available and are not treated as evidence.
- [5e-database](https://github.com/5e-bits/5e-database) is archived according
  to both its README and GitHub repository metadata. Its README points to
  [5e-srd-api](https://github.com/5e-bits/5e-srd-api), observed unarchived.
  RPG terms can inform presentation only; no database, game rules, or dependency
  is imported. Licensing must be reviewed before copying reference content.
- Local Claude CLI help confirmed `--effort low`, `--tools ""`, strict MCP
  configuration, empty setting sources, no session persistence, JSON output,
  and the native dollar-budget option used by the headless adapter.
  This is installed-CLI evidence, not a guarantee for other client versions.

Agent Finder discovery returned the following leads. Scores are relevance only,
not trust or security ratings; none were installed:

1. **Github**, Claude plugin, score 90:
   https://github.com/anthropics/claude-plugins-public/blob/main/external_plugins/github
2. **Sourcegraph MCP Server**, MCP server, score 80:
   https://api.mcp.github.com/oss/v0.1/servers/io.github.sourcegraph%2Fmcp/versions/latest
3. **CLI Code Reviewer**, skill, score 70:
   https://github.com/cli/cli/blob/trunk/.github/skills/cli-code-reviewer/SKILL.md

The last result is GitHub CLI-specific, not an Avalhla review contract. Existing
GitHub tooling is preferable to installing these merely because they were found.

## Desktop Commander / deployment research 2026-10-05

Observed repository revision:
[`c774c3b505de990219637ecdc9a830c8772fae9d`](https://github.com/wonderwhy-er/DesktopCommanderMCP/tree/c774c3b505de990219637ecdc9a830c8772fae9d).
The repository is unarchived; its package manifest declares MIT licensing,
version `0.2.52`, and Node.js `>=18.0.0`. This is a source inspection, not an
installation, dependency audit, or runtime certification.

### One product / separate connection boundaries

The [Claude plugin manifest](https://github.com/wonderwhy-er/DesktopCommanderMCP/blob/c774c3b505de990219637ecdc9a830c8772fae9d/plugins/claude/.claude-plugin/plugin.json)
declares a local stdio MCP server plus workflow skills. Its command uses
`npx -y @wonderwhy-er/desktop-commander@latest`. The manifest's plugin version
`0.2.0` is not the MCP package version. A future deployment should pin the
package/image separately rather than treating a plugin revision as a runtime pin.
No plugin was installed in this research pass.

Local stdio and Remote are not interchangeable:

```text
LOCAL CLIENT -> STDIO MCP -> LOCAL PROCESS

REMOTE CLIENT -> REMOTE MCP SERVICE -> PAIRED DEVICE -> LOCAL MCP
                arguments/results cross this service
```

The [Remote guide](https://github.com/wonderwhy-er/DesktopCommanderMCP/blob/c774c3b505de990219637ecdc9a830c8772fae9d/src/remote-device/README.md)
documents browser-confirmed OAuth device authorization and a saved device
session. Restart normally reuses that session. Stopping the process takes the
device offline; local logout removes saved credentials but does not revoke
server-side authorization. Revocation and removing a client's connector are
separate actions. An identifier supplied in chat is not proof of any of them.
Never copy one service's credentials into an unrelated plugin or model project.

### Isolation / privacy / persistence

The [security policy](https://github.com/wonderwhy-er/DesktopCommanderMCP/blob/c774c3b505de990219637ecdc9a830c8772fae9d/SECURITY.md)
classifies the tool as privileged automation: directory allowlists and command
blocklists are guardrails, not a sandbox. Terminal commands execute with the
server's user permissions. OS-level isolation is needed when the client must
not reach the host. Container safety depends on mounts, capabilities, sockets,
network access, and runtime configuration; README claims of "zero risk" are
not adopted as verified facts.

The [README history section](https://github.com/wonderwhy-er/DesktopCommanderMCP/blob/c774c3b505de990219637ecdc9a830c8772fae9d/README.md#local-tool-history-and-audit-logs)
states that local tool-call argument logs are unredacted. Remote routing also
temporarily stores arguments/results. The
[privacy policy](https://github.com/wonderwhy-er/DesktopCommanderMCP/blob/c774c3b505de990219637ecdc9a830c8772fae9d/PRIVACY.md)
describes optional telemetry as enabled by default, with an opt-out setting.
Telemetry, local logs, and Remote transit are different data paths. None was
disabled or reconfigured by this research.

**Decision: HOLD activation; candidate for an isolated local stdio trial.**
Before enablement, inspect a pinned artifact, mount only a disposable public
fixture, avoid host sockets/credentials, verify denied host access and clean
shutdown, and document log retention. Remote pairing/revocation requires a
separate test. Existing `ava-team.py` reviewers intentionally remain tool-free;
adding this plugin to them would change that tested boundary.

## Additional integration candidates / 2026-10-05

Public-source research only: no candidate code, installer, model training,
credential flow, or gateway tool was executed. Repository documentation and
research benchmarks are project claims, not Avalhla measurements.

| Candidate / observed revision | Actual purpose | Decision for Avalhla |
|---|---|---|
| [Mini-Omni-Reasoner](https://github.com/xzf-thu/Mini-Omni-Reasoner/tree/d8af7984e4693114516ce973c152ba00035b1f4b) | MIT-licensed speech-reasoning research built on Qwen2.5-Omni-3B; not a coding-review MCP plugin | HOLD deployment; possible future voice research |
| [LowRankClone](https://github.com/CURRENTF/LowRankClone/tree/7b458b266e93d1c83f888f6b67e48e1c70f3e985) | Teacher/student model distillation with low-rank projections; heavyweight training, not a drop-in inference adapter | HOLD; licensing and hardware feasibility unresolved |
| [RayCodes_FreeToken](https://github.com/47thtechcorner/RayCodes_FreeToken/tree/cea93d078e861098c205f68f9880ba8c4754df6b) | Tutorial wrapper around an optional separate inference package, with a canned fallback report | HOLD; not measured inference evidence or cloud token entitlement |
| [xmltokenizer](https://github.com/muktihari/xmltokenizer/tree/5d45a12228369e198fb41135f746002ad29966cf) | MIT-licensed Go XML tokenizer, not an LLM token counter | RESEARCH only for a concrete Go/XML parsing requirement |

### Model research is not a plugin install

Mini-Omni-Reasoner's
[README](https://github.com/xzf-thu/Mini-Omni-Reasoner/blob/d8af7984e4693114516ce973c152ba00035b1f4b/README.md)
describes interleaved speech reasoning and points to its research report.
It does not establish a local coding/review backend, MCP interface, or a
verified memory requirement on Dawa's machine. Promised releases are not proof
that every training artifact or dataset was delivered.

LowRankClone's
[README](https://github.com/CURRENTF/LowRankClone/blob/7b458b266e93d1c83f888f6b67e48e1c70f3e985/README.md)
describes a distillation/training workflow with version-sensitive GPU
dependencies and multi-GPU examples. No repository license was found in this
inspection; do not infer redistribution rights from public visibility.
Reference training hardware is not a proved minimum for every configuration.
Student-checkpoint licensing and inference compatibility require their own
review before any deployment. Neither project changes Avalhla's active model.

### FreeToken name / measurement boundary

The RayCodes tutorial's
[main.py](https://github.com/47thtechcorner/RayCodes_FreeToken/blob/cea93d078e861098c205f68f9880ba8c4754df6b/main.py)
optionally imports `freetoken` and provides a fallback with a fixed speed value
and canned report. That fallback must not be counted as a successful model run
or benchmark. No repository license was found for the tutorial.

The separate [FlashML-org/FreeToken](https://github.com/FlashML-org/FreeToken)
is a lead, not an adopted or independently audited Avalhla backend. Its identity,
package provenance, model licensing, runtime behavior, and hardware fit need a
bounded follow-up before installation. Local inference may avoid a cloud
inference invoice; it still consumes memory, compute, power, and context.
The tutorial supplies no proof of free cloud-provider credits. No credential
reuse, quota bypass, or provider authentication change follows from its name.

### XML tokens are not model tokens

The xmltokenizer
[README](https://github.com/muktihari/xmltokenizer/blob/5d45a12228369e198fb41135f746002ad29966cf/README.md)
and [module declaration](https://github.com/muktihari/xmltokenizer/blob/5d45a12228369e198fb41135f746002ad29966cf/go.mod)
describe Go XML parsing. Its non-namespace design and parsing benchmarks do
not establish LLM token savings, prompt compression, or compatibility with
namespace-dependent XML formats. Avalhla has no demonstrated need to add this
dependency in the current Python review adapter.

## GDP / Git Diff Patcher Bridge / 2026-10-05

The [methetech GitHub profile](https://github.com/methetech) alone did not
identify the gateway. First-party Help documentation subsequently established
GDP's published connection path; the initial lack of GitHub source was not
evidence that the product did not exist.

The [connection guide](https://methe.tech/help/gdp/connect-chatgpt-to-gdp)
explicitly names `https://mcp.methe.tech/gdp/mcp`, browser authorization,
Demo Workspace, and a connected GDP Desktop workflow. An unauthenticated GET
to the endpoint returned HTTP 200 with HTML. This verifies reachability and
published endpoint provenance, not an MCP handshake, account authentication,
node selection, enforced routing, or successful execution.

A subsequent anonymous, metadata-only JSON-RPC `initialize` probe on
2026-10-05 succeeded with `serverInfo.name = methetech-gdp-gateway`,
`serverInfo.version = 0.3.0`, and protocol version `2025-06-18`.
It advertised tool-catalog change notifications and resources without change
notifications. No account identifier, credential, repository contents, or
private snapshot was sent. Server instructions were treated as untrusted
remote content, not an operating contract.

This establishes a protocol handshake only. It does not prove authenticated
tool access, correct node/workspace selection, account allowances, routing,
or local execution. No `tools/list` or `tools/call` was performed. A public
handshake is not evidence that material tools are unauthenticated.

The [repository tool reference](https://methe.tech/help/gdp/gdp-repository-tool-reference)
describes a caller-effective, variable tool catalog. Pasted tool descriptions
are useful leads, but not live schemas or evidence that a capability is exposed
in this CLI session. Absence of a name in public Help is not proof that a
user-supplied catalog is false. GDP's worker terminology must not be equated
with Microsoft Fabric Spark merely because both use the word "Spark."

The published architecture preserves GDP Desktop's local execution/policy
boundary. Hosted patch intake is not patch application, suggested checks are
not command execution, and a publication request is not a commit/push receipt.
Selected repository context can cross the AI host/gateway; "local-first" does
not mean every data path is offline. These are documented design boundaries,
not an independent implementation audit.

The [plans and entitlements guide](https://methe.tech/help/gdp/understand-gdp-plans-and-entitlements)
explicitly defers numeric allowances to live Pricing and account Profile.
The [usage and queue guide](https://methe.tech/help/gdp/understand-gdp-cloud-usage-and-queue)
separates gateway metering and admission from execution authority. No account
balance or numeric entitlement was verified. Gateway units must not be
converted to model tokens or reviewer credits without a documented conversion.
Private identifiers and supplied account snapshots are intentionally excluded.

**Decision: RESEARCH / readiness verification before integration.**
Use the actual connected host's read-only discovery and exact effective schemas
when available. Establish the selected node, workspace/repository, limits, and
authority separately before any material request. Do not invent a bearer token
from an identifier, share Desktop Commander credentials, install GDP from an
unverified download, or retry a possibly non-idempotent dispatch blindly.
No authenticated GDP connector was configured or authorized; no GDP repository
or execution tool was invoked. The anonymous protocol probe is separate from
an installed, authenticated connector in the current CLI.
