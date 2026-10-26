# CLAUDE.md

Claude Code adapter for Avalhla. `AGENTS.md` is the canonical contract; if they
conflict, `AGENTS.md` and current source win.

@AGENTS.md

Avalhla = Bash "doors" (`scripts/ava-*`, `scripts/ai-*`) around a local Ollama
model. Safety and output boundaries are deterministic shell code; the model sees
approved input and proposes, Dawa chooses. Orientation: `docs/SOURCE_MAP.md`,
`ORDER.md`, `docs/AVALHLA_SPINE.md`, `docs/PHASING.md`, `docs/HANDOFF.md` (read
first). Library roles: header comments in `scripts/lib_*`.

## Commands

- Full gate (= CI `avalhla-static-contract`): `bash scripts/ava-ci-contract`, must end `result: ALL GREEN`
- One shell contract: `bash tests/test_<name>.sh`
- Python contracts: `PYTHONDONTWRITEBYTECODE=1 python3 tests/test_action_proposal.py` and `tests/test_ava_context.py`
- Lint: `shellcheck scripts/<door>`, `bash -n scripts/<door>`
- Read-only orientation: `scripts/ava-cobuilder init`, `scripts/ava-resume review`, `scripts/ava-help --list`, `scripts/ava-safety --self-test`
- Needs Ollama at 127.0.0.1:11434: `ai-chat`, `ai-ask`, `ava-verify`, `ava-explain`, `ava-review`, `ava-github-review --synthesize`
- `make bin` symlinks scripts into gitignored `bin/`

## Gotchas

- `lib_runtime.sh` hard-codes `AVA_ROOT=/var/home/VVgbon/Avalhla` and ignores env.
  Doors that source it act on the canonical root from any worktree; worktree-safe
  doors derive ROOT from their own path (see `ava-resume`, `ava-ci-contract`).
- A new test goes into `scripts/ava-ci-contract` twice: canonical-files list and a run line.
- Tests stay hermetic: `mktemp -d` + `trap`, stubbed `curl`, env overrides
  (`AVA_MOOD_DIR`, `AVA_IMAGINE_ROOT`); never touch real `memory/` or a live model.
- Gate also enforces: mode 755 on core doors, auto-read Color Field pointer-only,
  historical aliases only in `scripts/ava-reality`, no `Dawa_Notepad` path in the
  public tree or `ava-sublime-update`, legacy relation-label grep.
- `memory/` is gitignored private state; the one tracked file is
  `memory/auto-read/00_AI_COBUILD.json` (~110 KB). Edit by key, keep valid JSON.
- Host is immutable Bazzite: develop in Distrobox, no host package installs.
- Untracked `.agents/`, `avalhla-cobuilder-8x/`, `archives/`, `CODEX 1st time whit chatgpt`
  are not canon; stage only on Dawa's word. `.codex/` is Codex config, not Claude's.

## Working here

- Update the canonical artifact, not a parallel doc. Note changes under `## [Unreleased]` in `CHANGELOG.md`.
- Preserve dirty worktrees. Commit, push and merge wait for Dawa.
