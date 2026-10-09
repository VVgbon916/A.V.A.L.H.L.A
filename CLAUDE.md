# CLAUDE.md

Claude Code adapter for Avalhla. `AGENTS.md` is the canonical review and
CoBuilder contract and is imported below. This file only adds operating facts
for Claude Code. If they conflict, `AGENTS.md` and current source win.

@AGENTS.md

## What this is

Avalhla is a local AI companion: Bash "doors" (`scripts/ava-*`, `scripts/ai-*`)
around a local Ollama model (`persona/*.Modelfile`). Safety, context and output
boundaries are deterministic shell code outside the model. The model sees
approved input and proposes. Dawa chooses.

Start here: `docs/SOURCE_MAP.md` (what lives where), `ORDER.md` (reading
order), `docs/AVALHLA_SPINE.md` (authority + data flow), `docs/PHASING.md`
(phase gates), `docs/HANDOFF.md` (current resume state; read first).

## Commands

- Full gate, identical to CI check `avalhla-static-contract`:
  `bash scripts/ava-ci-contract` (must end `result: ALL GREEN`)
- One shell contract: `bash tests/test_<name>.sh`
- Python contracts: `PYTHONDONTWRITEBYTECODE=1 python3 tests/test_action_proposal.py`
  and `PYTHONDONTWRITEBYTECODE=1 python3 tests/test_ava_context.py`
- Lint / syntax: `shellcheck scripts/<door>`, `bash -n scripts/<door>`
- Read-only orientation: `scripts/ava-cobuilder init`, `scripts/ava-resume review`,
  `scripts/ava-help --list`, `scripts/ava-safety --self-test`
- Needs local Ollama (127.0.0.1:11434): `ai-chat`, `ai-ask`, `ava-verify`,
  `ava-explain`, `ava-review`, `ava-github-review --synthesize`
- `make bin` symlinks executable scripts into gitignored `bin/`

## Architecture

Flow: input -> `lib_runtime` -> `lib_safety` -> `lib_context` /
`lib_model_input` -> door or model -> `lib_output_gate` -> Dawa.

`scripts/lib_*` are sourced, never executed:

| Lib | Owns |
|---|---|
| `lib_runtime.sh` | canonical paths, model names, `OLLAMA_HOST`, pagers off |
| `lib_safety.sh` | capability policy (network/shell/system mutation denied), bounded read/write |
| `lib_context.sh` | bounded context bridge |
| `lib_model_input.sh` | labels and caps untrusted model input (`AVA_MODEL_INPUT_MAX_BYTES`, default 65536) |
| `lib_output_gate.sh`, `lib_redact.sh` | strip `[READ:]` tokens, redact model output |
| `lib_review_gate.sh` | exact review verdict validation |
| `lib_integrity.sh`, `lib_color_field.sh` | SHA-256 identity, Color Field accessors |
| `lib_action.py` | typed, non-persistent action proposals |

Other areas: `config/` (Color Field, integrity registry, naming/doors,
Sublime prefs, shell examples), `persona/` (Ollama Modelfiles), `.codex/`
(Codex agent config, not Claude config), `systemd/` (reflect timer).

`memory/` is gitignored private runtime state. The single tracked exception is
`memory/auto-read/00_AI_COBUILD.json`, the machine CoBuilder state. Edit it
with targeted changes and keep it valid JSON.

## Gotchas

- `lib_runtime.sh` hard-codes `AVA_ROOT=/var/home/VVgbon/Avalhla` and ignores
  inherited env. Doors that source it act on the canonical root even when run
  from another worktree. Doors that must be worktree-safe derive ROOT from
  their own path (see `scripts/ava-resume`, `scripts/ava-ci-contract`).
- A new test goes into `scripts/ava-ci-contract` twice: the canonical-files
  list and a run line in the matching section.
- Tests stay hermetic: `mktemp -d` + `trap` cleanup, stubbed `curl`, env
  overrides (`AVA_MOOD_DIR`, `AVA_IMAGINE_ROOT`). They never touch real
  `memory/` or a live model.
- The gate also enforces: mode 755 on core doors, auto-read Color Field
  stays pointer-only, historical aliases stay in `scripts/ava-reality`, no
  `Dawa_Notepad` path in the public tree or `ava-sublime-update`, and a
  legacy relation-label grep (see the "semantic invariants" block).
- Host is immutable Bazzite. Develop in Distrobox and never use host package installs.
- Untracked local material (`.agents/`, `avalhla-cobuilder-8x/`, `archives/`,
  `CODEX 1st time whit chatgpt`) is not canon. Stage it only on Dawa's word.

## Working here

- Reply shape: TITLE -> FAST VIEW -> TODO -> STEP DIVIDER -> COPY BLOCK.
- Update the canonical artifact instead of adding a parallel doc.
- Note notable changes under `## [Unreleased]` in `CHANGELOG.md`.
- Preserve dirty worktrees. Commit, push and merge wait for Dawa.
