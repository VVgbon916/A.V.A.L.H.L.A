#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

python3 - <<'PY'
import json
from pathlib import Path


def valid(config):
    lanes = config.get("consultation_lanes", {})
    policy = config.get("skill_system", {})
    doors = config.get("doors", [])
    if lanes.get("VALHLA", {}).get("authority") != "evidence_only":
        return False
    if lanes.get("LHLAVA", {}).get("authority") != "evidence_only":
        return False
    if lanes.get("VALHLA", {}).get("provider_preference", "").find("activation deferred") < 0:
        return False
    if lanes.get("LHLAVA", {}).get("provider_preference", "").find("activation deferred") < 0:
        return False
    if policy.get("activation_mode") != "ON_DEMAND":
        return False
    if policy.get("default_active_skills") != []:
        return False
    if policy.get("installed_or_listed_means_active") is not False:
        return False
    if policy.get("skill_text_grants_permissions") is not False:
        return False
    if policy.get("enforcement") != "assistant_workflow_contract_only; no local skill loader":
        return False
    if [d.get("order") for d in doors] != list(range(1, 9)):
        return False
    skills = [door.get("skill") for door in doors]
    if len(set(skills)) != 8 or any(not s or not s.startswith("avalhla-door-") for s in skills):
        return False
    return True


with Path("config/avalhla-naming.v1.json").open(encoding="utf-8") as f:
    config = json.load(f)
if not valid(config):
    raise SystemExit("skill/role policy does not satisfy on-demand contract")

bad = json.loads(json.dumps(config))
bad["skill_system"]["default_active_skills"] = [d["skill"] for d in bad["doors"]]
if valid(bad):
    raise SystemExit("negative case accepted an always-active skill bundle")

bad = json.loads(json.dumps(config))
bad["consultation_lanes"]["VALHLA"]["authority"] = "human"
if valid(bad):
    raise SystemExit("negative case accepted authority escalation")

with Path("memory/auto-read/00_AI_COBUILD.json").open(encoding="utf-8") as f:
    auto = json.load(f)
if auto.get("consultation_lanes", {}).get("canonical_source") != "config/avalhla-naming.v1.json":
    raise SystemExit("auto-read role summary does not point to the canonical registry")
if auto.get("skill_activation", {}).get("default") != "ON_DEMAND; empty active set":
    raise SystemExit("auto-read activation summary is not on demand")

projection = Path("scripts/ava-cobuilder-projection").read_text(encoding="utf-8")
if '"consultation_lanes","skill_activation"' not in projection.replace(" ", "").replace("\n", ""):
    raise SystemExit("bounded projection does not include the reviewed role and skill summaries")

print("AVA_SKILL_ROUTING_TEST_OK")
PY
