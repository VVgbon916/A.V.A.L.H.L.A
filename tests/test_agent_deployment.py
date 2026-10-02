#!/usr/bin/env python3
"""Contract tests for the project-scoped Avalhla agent deployment."""

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "config/agents/avalhla-agents.v1.json"
VALIDATOR = ROOT / "scripts/ava-agent-check"


class AgentDeploymentRegistryTests(unittest.TestCase):
    def load_registry(self):
        self.assertTrue(REGISTRY.is_file(), f"missing registry: {REGISTRY}")
        return json.loads(REGISTRY.read_text(encoding="utf-8"))

    def test_canonical_roles_and_engine_ownership(self):
        registry = self.load_registry()
        roles = registry["canonical_roles"]
        self.assertEqual(
            set(roles), {"TRACE", "STRIKE", "FORGE", "MIRROR", "VALHLA", "LUX"}
        )
        self.assertEqual(roles["STRIKE"]["engine"], "claude")
        for role in ("TRACE", "FORGE", "MIRROR", "VALHLA", "LUX"):
            self.assertEqual(roles[role]["engine"], "codex", role)

    def test_only_forge_and_mirror_are_workspace_writers(self):
        roles = self.load_registry()["canonical_roles"]
        permission_classes = {
            role: record["permission_class"] for role, record in roles.items()
        }
        self.assertEqual(
            permission_classes,
            {
                "TRACE": "read-only",
                "STRIKE": "read-only",
                "FORGE": "workspace-write",
                "MIRROR": "workspace-write",
                "VALHLA": "read-only",
                "LUX": "read-only",
            },
        )

    def test_strike_has_exactly_eight_read_only_evidence_lanes(self):
        lanes = self.load_registry()["strike_lanes"]
        self.assertEqual(
            [lane["name"] for lane in lanes],
            [
                "SOURCE",
                "HISTORY",
                "RUNTIME",
                "PRIMARY",
                "INDEPENDENT",
                "COUNTER",
                "ADVERSARIAL",
                "REVIEW",
            ],
        )
        self.assertEqual(len({lane["agent"] for lane in lanes}), 8)
        self.assertTrue(all(lane["engine"] == "claude" for lane in lanes))
        self.assertTrue(
            all(lane["permission_class"] == "read-only" for lane in lanes)
        )

    def test_legacy_agent_names_are_compatibility_aliases_only(self):
        registry = self.load_registry()
        self.assertEqual(
            registry["legacy_aliases"],
            {"WITNESS": "TRACE", "ECHO": "MIRROR"},
        )
        self.assertTrue(
            set(registry["legacy_aliases"]).isdisjoint(registry["canonical_roles"])
        )
        lane_agents = {lane["agent"].casefold() for lane in registry["strike_lanes"]}
        self.assertTrue(
            {alias.casefold() for alias in registry["legacy_aliases"]}.isdisjoint(
                lane_agents
            )
        )

    def test_human_authority_is_explicit(self):
        self.assertEqual(self.load_registry()["authority"], "Dawa chooses.")

    def test_registry_contains_no_volatile_state_keys(self):
        registry = self.load_registry()
        forbidden = {
            "branch",
            "head",
            "sha",
            "commit",
            "latest_pr",
            "next_command",
            "resolved_defect",
            "resolved_defects",
        }

        def keys(value):
            if isinstance(value, dict):
                for key, child in value.items():
                    yield key.casefold()
                    yield from keys(child)
            elif isinstance(value, list):
                for child in value:
                    yield from keys(child)

        self.assertTrue(forbidden.isdisjoint(keys(registry)))


class AgentDeploymentValidatorTests(unittest.TestCase):
    def load_valid_registry(self):
        return json.loads(REGISTRY.read_text(encoding="utf-8"))

    def run_fixture_validator(self, registry, files=None, setup=None):
        with tempfile.TemporaryDirectory() as tmp:
            fixture_root = Path(tmp) / "project"
            registry_dir = fixture_root / "config/agents"
            registry_dir.mkdir(parents=True)
            (registry_dir / "avalhla-agents.v1.json").write_text(
                json.dumps(registry), encoding="utf-8"
            )
            for relative, content in (files or {}).items():
                project_file = fixture_root / relative
                project_file.parent.mkdir(parents=True, exist_ok=True)
                project_file.write_text(content, encoding="utf-8")
            if setup is not None:
                setup(fixture_root, Path(tmp))

            fixture_validator = fixture_root / "scripts/ava-agent-check"
            fixture_validator.parent.mkdir(parents=True)
            fixture_validator.write_bytes(VALIDATOR.read_bytes())
            fixture_validator.chmod(0o755)
            return subprocess.run(
                [str(fixture_validator)],
                cwd=fixture_root,
                text=True,
                capture_output=True,
                check=False,
            )

    def test_validator_is_executable_and_accepts_task_one_contract(self):
        self.assertTrue(VALIDATOR.is_file(), f"missing validator: {VALIDATOR}")
        self.assertTrue(os.access(VALIDATOR, os.X_OK), "validator is not executable")
        result = subprocess.run(
            [str(VALIDATOR)], cwd=ROOT, text=True, capture_output=True, check=False
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("AGENT_CONTRACT=PASS", result.stdout)

    def test_validator_rejects_static_permission_drift(self):
        self.assertTrue(VALIDATOR.is_file(), f"missing validator: {VALIDATOR}")
        result = self.run_fixture_validator(
            self.load_valid_registry(),
            {".codex/agents/trace.toml": 'sandbox_mode = "workspace-write"\n'},
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("permission setting drift", result.stdout + result.stderr)

    def test_validator_rejects_toml_comment_permission_spoofing(self):
        result = self.run_fixture_validator(
            self.load_valid_registry(),
            {
                ".codex/agents/trace.toml": (
                    'sandbox_mode = "workspace-write"\n'
                    '# sandbox_mode = "read-only"\n'
                )
            },
        )

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("permission setting drift", result.stdout + result.stderr)

    def test_validator_rejects_markdown_body_permission_spoofing(self):
        result = self.run_fixture_validator(
            self.load_valid_registry(),
            {
                ".claude/agents/strike.md": (
                    "---\n"
                    "name: strike\n"
                    "permissionMode: acceptEdits\n"
                    "---\n"
                    "permissionMode: plan\n"
                )
            },
        )

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("permission setting drift", result.stdout + result.stderr)

    def test_validator_rejects_permission_class_marker_mismatch(self):
        registry = self.load_valid_registry()
        registry["canonical_roles"]["TRACE"]["permission_marker"] = (
            'sandbox_mode = "workspace-write"'
        )

        result = self.run_fixture_validator(registry)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("permission marker mismatch", result.stdout + result.stderr)

    def test_validator_rejects_registry_shape_drift(self):
        valid = self.load_valid_registry()
        cases = {}

        empty = json.loads(json.dumps(valid))
        empty["canonical_roles"] = {}
        empty["strike_lanes"] = []
        cases["empty"] = empty

        truncated = json.loads(json.dumps(valid))
        del truncated["canonical_roles"]["LUX"]
        truncated["strike_lanes"].pop()
        cases["truncated"] = truncated

        extra_role = json.loads(json.dumps(valid))
        extra_role["canonical_roles"]["OTHER"] = dict(
            extra_role["canonical_roles"]["TRACE"]
        )
        cases["extra role"] = extra_role

        renamed_lane = json.loads(json.dumps(valid))
        renamed_lane["strike_lanes"][0]["name"] = "OTHER"
        cases["renamed lane"] = renamed_lane

        bad_role_engine = json.loads(json.dumps(valid))
        bad_role_engine["canonical_roles"]["STRIKE"]["engine"] = "codex"
        cases["role engine"] = bad_role_engine

        bad_lane_engine = json.loads(json.dumps(valid))
        bad_lane_engine["strike_lanes"][0]["engine"] = "codex"
        cases["lane engine"] = bad_lane_engine

        bad_authority = json.loads(json.dumps(valid))
        bad_authority["authority"] = "Model chooses."
        cases["authority"] = bad_authority

        for name, registry in cases.items():
            with self.subTest(name=name):
                result = self.run_fixture_validator(registry)
                self.assertNotEqual(
                    result.returncode, 0, result.stdout + result.stderr
                )
                self.assertIn("registry contract drift", result.stdout + result.stderr)

    def test_validator_rejects_absolute_and_traversal_project_paths(self):
        for name, project_file in {
            "absolute": "/tmp/trace.toml",
            "traversal": ".codex/../outside.toml",
        }.items():
            with self.subTest(name=name):
                registry = self.load_valid_registry()
                registry["canonical_roles"]["TRACE"]["project_file"] = project_file
                result = self.run_fixture_validator(registry)
                self.assertNotEqual(
                    result.returncode, 0, result.stdout + result.stderr
                )
                self.assertIn("must remain inside the project", result.stdout)

    def test_validator_rejects_symlinked_file_escape(self):
        def symlinked_file(fixture_root, temp_root):
            outside_file = temp_root / "outside.toml"
            outside_file.write_text('sandbox_mode = "read-only"\n', encoding="utf-8")
            link = fixture_root / ".codex/agents/trace.toml"
            link.parent.mkdir(parents=True)
            link.symlink_to(outside_file)

        file_result = self.run_fixture_validator(
            self.load_valid_registry(), setup=symlinked_file
        )
        self.assertNotEqual(file_result.returncode, 0)
        self.assertIn("symlink", file_result.stdout.casefold())

    def test_validator_rejects_symlinked_path_component(self):
        component_registry = self.load_valid_registry()
        component_registry["canonical_roles"]["TRACE"]["project_file"] = (
            ".agent-link/trace.toml"
        )

        def symlinked_component(fixture_root, temp_root):
            real_dir = fixture_root / ".real-agents"
            real_dir.mkdir()
            (real_dir / "trace.toml").write_text(
                'sandbox_mode = "read-only"\n', encoding="utf-8"
            )
            (fixture_root / ".agent-link").symlink_to(
                real_dir, target_is_directory=True
            )

        component_result = self.run_fixture_validator(
            component_registry, setup=symlinked_component
        )
        self.assertNotEqual(component_result.returncode, 0)
        self.assertIn("symlink", component_result.stdout.casefold())

    def test_validator_root_cannot_be_redirected_by_environment(self):
        with tempfile.TemporaryDirectory() as tmp:
            environment = os.environ.copy()
            environment["AVA_AGENT_ROOT"] = tmp
            result = subprocess.run(
                [str(VALIDATOR)],
                cwd=ROOT,
                env=environment,
                text=True,
                capture_output=True,
                check=False,
            )

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("AGENT_CONTRACT=PASS", result.stdout)

    def test_live_inventory_uses_only_version_and_mcp_list_commands(self):
        self.assertTrue(VALIDATOR.is_file(), f"missing validator: {VALIDATOR}")
        with tempfile.TemporaryDirectory() as tmp:
            fixture_dir = Path(tmp)
            call_log = fixture_dir / "calls.log"
            for tool in ("claude", "codex"):
                fake = fixture_dir / tool
                version_warning = (
                    '  echo "codex environment warning" >&2\n' if tool == "codex" else ""
                )
                fake.write_text(
                    "".join(
                        [
                            "#!/usr/bin/env bash\n",
                            'echo "$(basename "$0") $* cwd=$PWD" >> "$AVA_AGENT_CALL_LOG"\n',
                            'if [[ "$1" == "--version" ]]; then\n',
                            version_warning,
                            f'  echo "{tool} test-version"\n',
                            'elif [[ "$1 $2" == "mcp list" ]]; then\n',
                            f'  echo "{tool}-test-mcp"\n',
                            "else\n",
                            "  exit 90\n",
                            "fi\n",
                        ]
                    ),
                    encoding="utf-8",
                )
                fake.chmod(0o755)

            environment = os.environ.copy()
            environment["PATH"] = f"{fixture_dir}:{environment['PATH']}"
            environment["AVA_AGENT_CALL_LOG"] = str(call_log)
            caller_dir = fixture_dir / "caller"
            caller_dir.mkdir()
            result = subprocess.run(
                [str(VALIDATOR), "--live"],
                cwd=caller_dir,
                env=environment,
                text=True,
                capture_output=True,
                check=False,
            )
            calls = call_log.read_text(encoding="utf-8").splitlines() if call_log.exists() else []

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("CLAUDE_VERSION=claude test-version", result.stdout)
        self.assertIn("CODEX_VERSION=codex test-version", result.stdout)
        self.assertIn("claude-test-mcp", result.stdout)
        self.assertIn("codex-test-mcp", result.stdout)
        self.assertEqual(
            calls,
            [
                f"claude --version cwd={ROOT}",
                f"claude mcp list cwd={ROOT}",
                f"codex --version cwd={ROOT}",
                f"codex mcp list cwd={ROOT}",
            ],
        )


class ClaudeAgentDeploymentTests(unittest.TestCase):
    """Task 2 contracts; no Claude execution or model calls are needed."""

    AGENTS = {
        "strike", "strike-source", "strike-history", "strike-runtime",
        "strike-primary", "strike-independent", "strike-counter", "vex",
        "strike-review", "lhlava",
    }
    SEARCH_TOOLS = {"Read", "Glob", "Grep", "WebSearch", "WebFetch"}

    def read_project_file(self, relative):
        path = ROOT / relative
        self.assertTrue(path.is_file(), f"missing Task 2 deployment: {relative}")
        for component in (path, *path.parents):
            if component == ROOT:
                break
            self.assertFalse(component.is_symlink(), f"project symlink: {component}")
        self.assertTrue(path.resolve().is_relative_to(ROOT))
        return path.read_text(encoding="utf-8")

    def load_agent(self, name):
        text = self.read_project_file(f".claude/agents/{name}.md")
        lines = text.splitlines()
        self.assertEqual(lines[0], "---", name)
        self.assertIn("---", lines[1:], f"unclosed frontmatter: {name}")
        end = lines.index("---", 1)
        frontmatter = {}
        for line in lines[1:end]:
            key, separator, value = line.partition(":")
            self.assertTrue(separator, f"invalid frontmatter: {name}: {line}")
            self.assertNotIn(key, frontmatter, f"duplicate field: {name}: {key}")
            frontmatter[key] = value.strip()
        self.assertEqual(set(frontmatter), {"name", "description", "tools", "permissionMode"})
        self.assertTrue(frontmatter["description"], name)
        body = "\n".join(lines[end + 1:])
        self.assertTrue(body.strip(), f"missing instructions: {name}")
        return frontmatter, body

    def test_project_inventory_and_unique_discovery_names(self):
        directory = ROOT / ".claude/agents"
        self.assertTrue(directory.is_dir(), "missing Task 2 deployment: .claude/agents")
        self.assertEqual({path.name for path in directory.iterdir()},
                         {f"{name}.md" for name in self.AGENTS})
        names = []
        for name in sorted(self.AGENTS):
            with self.subTest(agent=name):
                fields, _ = self.load_agent(name)
                self.assertEqual(fields["name"], name)
                names.append(fields["name"])
        self.assertEqual(len(set(names)), 10)

    def test_every_agent_uses_plan_permission_mode(self):
        for name in sorted(self.AGENTS):
            with self.subTest(agent=name):
                fields, _ = self.load_agent(name)
                self.assertEqual(fields["permissionMode"], "plan")

    def test_tool_allowlists_prevent_writes_and_worker_delegation(self):
        for name in sorted(self.AGENTS):
            with self.subTest(agent=name):
                fields, _ = self.load_agent(name)
                listed = [tool.strip() for tool in fields["tools"].split(",")]
                tools = set(listed)
                self.assertEqual(len(listed), len(tools), name)
                expected = self.SEARCH_TOOLS
                if name == "strike":
                    expected = expected | {"Agent"}
                elif name == "strike-runtime":
                    expected = {"Read", "Glob", "Grep", "Bash"}
                self.assertEqual(tools, expected)
                self.assertTrue({"Write", "Edit", "NotebookEdit"}.isdisjoint(tools))
                if name != "strike":
                    self.assertNotIn("Agent", tools)

    def test_eight_lane_identities_and_dispatch_match_registry(self):
        registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
        _, strike_body = self.load_agent("strike")
        self.assertEqual(registry["canonical_roles"]["STRIKE"]["project_file"],
                         ".claude/agents/strike.md")
        lanes = registry["strike_lanes"]
        self.assertEqual(len(lanes), 8)
        self.assertEqual({lane["agent"] for lane in lanes}, self.AGENTS - {"strike", "lhlava"})
        for lane in lanes:
            with self.subTest(lane=lane["name"]):
                self.assertEqual(lane["project_file"], f".claude/agents/{lane['agent']}.md")
                fields, body = self.load_agent(lane["agent"])
                self.assertEqual(fields["name"], lane["agent"])
                self.assertIn(f"{lane['name']} -> {lane['agent']}", strike_body)
                self.assertIn(f"Lane: {lane['name']}", body)

    def test_project_settings_bound_spawn_depth_and_concurrency(self):
        settings = json.loads(self.read_project_file(".claude/settings.json"))
        self.assertEqual(set(settings), {"env"})
        self.assertEqual(settings["env"], {
            "CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH": "2",
            "CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS": "9",
        })

    def test_runtime_explicitly_forbids_shell_mutation_paths(self):
        _, body = self.load_agent("strike-runtime")
        lowered = body.casefold()
        for prohibited in (
            "mutation", "package install", "process kill", "git write",
            "credential access", "system-state change",
        ):
            with self.subTest(prohibited=prohibited):
                self.assertIn(f"forbid {prohibited}", lowered)
        self.assertIn("observation commands only", lowered)

    def test_vex_is_active_adversarial_lane(self):
        _, body = self.load_agent("vex")
        self.assertIn("ACTIVE adversarial lane under STRIKE", body)
        self.assertIn("not a legacy alias", body)

    def test_lhlava_is_optional_mode_outside_strike_lanes(self):
        _, body = self.load_agent("lhlava")
        self.assertIn("optional forward-pressure/search mode", body)
        self.assertIn("not a canonical role, verifier, authority, or STRIKE lane", body)

    def test_all_agents_preserve_authority_and_private_input_boundaries(self):
        for name in sorted(self.AGENTS):
            with self.subTest(agent=name):
                _, body = self.load_agent(name)
                for boundary in (
                    "docs/COBUILDER_MASTER.md", "AGENTS.md", "Dawa chooses.",
                    "AvvA is the relation", "evidence, not authority",
                    "PRIVATE != AUTO-READ", "credential access",
                ):
                    self.assertIn(boundary, body)


if __name__ == "__main__":
    unittest.main(verbosity=2)
