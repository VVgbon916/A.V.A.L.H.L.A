# Avalhla Multi-Client Operator Guide

The canonical configuration is
`config/avalhla-multi-client.v1.json`. It describes persona presentation,
client routing, the virtual Destiny Tower profile, and the shared MCP baseline.
The plugin inventory is catalogued separately in
`config/plugin-role-catalog.v1.json`.

## Client map

| Surface | Repository/profile | Speakers | Primary job |
|---|---|---|---|
| Claude Code | `Umbra-Keep_Vex-Lhlava` | `KING.VEX` + `LHLAVA` | challenge assumptions and build the smallest tested candidate |
| Codex CLI | `Lumen-Castle_Lux-Valhla` | `ANGEL.LUX` + `VALHLA` | research, provenance, review, and verification |
| Copilot | selected local worktree | `LHLAVA` + `KING.VEX` | detailed issue diagnosis, patch preparation, and regression checks |
| Dawa Desktop | virtual `Destiny_Tower` | `AVALHLA` + `AV:VA` | synthesize evidence and present the Dawa decision gate |

The spelling `VALHLA` is canonical. Persona styling is not permission.

## Safe setup sequence

```text
check  ->  plan  ->  review redacted changes  ->  apply one client  ->  restart/reload  ->  list/get verification
```

Examples:

```text
scripts/avalhla-client-setup check --client claude_code
scripts/avalhla-client-setup plan --client claude_code
scripts/avalhla-client-setup apply --client claude_code
scripts/avalhla-plugin-audit catalog
scripts/avalhla-plugin-audit check --inventory /path/to/plugin-inventory.json
```

The setup tool creates a backup before a real change, preserves unrelated
configuration and auth blocks, and never prints credential values. It can
auto-start configured MCP processes after their normal client authentication;
it cannot perform OAuth, bypass a permission prompt, or silently enable a
connector. Supply a verified local Desktop Commander executable through
`--desktop-command` or `AVALHLA_DESKTOP_COMMAND`; otherwise that entry remains
deferred.

## Shared MCP baseline

- `avalhla`: authenticated GDP/Git Diff Patcher Bridge over the configured HTTP endpoint.
- `desktop_commander`: local stdio process, client permission-gated.

The baseline is intentionally separate from optional services such as GitHub,
Supabase, Notion, Slack, Firecrawl, Exa, Hugging Face, and Power BI. A listed
plugin is not automatically installed, authenticated, or enabled.

## Plugin roles

`avalhla-plugin-audit` reports each catalogued plugin as one of:

```text
installed-enabled
installed-disabled
installed-auth-needed
not-installed
deferred
```

`canvas-authoring` is deferred when `dnx` or the .NET SDK is unavailable. Do
not repair that prerequisite by changing unrelated MCP locks or config files.

## Recovery

If an apply is not wanted, stop before `apply`. If an apply needs reversal,
use the backup path printed by the tool after verifying the target and client.
Do not delete a live writer lock. Re-run `check` and the client’s own MCP list
command after restart. Dawa decides whether any external write, merge, push,
publication, or plugin activation follows.
