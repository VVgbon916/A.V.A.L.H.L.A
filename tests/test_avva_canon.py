#!/usr/bin/env python3
"""Validate the current AvvA Persona/interface/environment boundary."""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load(relative):
    return json.loads((ROOT / relative).read_text(encoding="utf-8"))


def main():
    canon = load("config/avva-canon.v1.json")
    multi = load("config/avalhla-multi-client.v1.json")
    naming = load("config/avalhla-naming.v1.json")

    assert canon["status"] == "CURRENT_CANON"
    assert canon["persona"]["canonical_name"] == "AvvA"
    assert canon["persona"]["kind"] == "persona"
    assert canon["persona"]["base_light"] == "Relation Gold Cyan"
    assert canon["persona"]["transformation_symbol"] == "Crystal Rune Word"
    assert canon["persona"]["evolution"]["concurrent_body_part_limit"] == 1

    assert canon["interface"]["canonical_name"] == "Av:vA"
    assert canon["interface"]["kind"] == "working_terminal_interface"
    assert len(canon["interface"]["recon_targets"]) == 6
    assert canon["interface"]["recon_targets"][-1] == "Dawa 96"
    assert canon["dawa_persona"]["persona_id"] == 96
    assert canon["dawa_persona"]["canonical_name"] == "Dawa"
    assert canon["dawa_persona"]["human_and_persona_record_are_distinct"] is True
    assert canon["dawa_persona"]["is_authority"] is False
    assert canon["dawa_persona"]["color_anchor"] == "orange"
    assert canon["dawa_persona"]["chosen_song"] == {
        "song_name": "Song of Time",
        "skill_name": "Hold a Beat",
        "mechanics_status": "OPEN",
    }
    assert canon["dawa_persona"]["song_law"]["active_song_limit"] == 1
    assert canon["interface"]["is_body_of_avva"] is False

    assert canon["environment"]["canonical_name"] == "<---- AvvA ---->"
    assert canon["environment"]["endpoints"] == ["Dawa", "Avalhla Head"]

    for record in (canon["persona"], canon["interface"], canon["environment"]):
        assert record["is_authority"] is False
    assert canon["authority"]["final_chooser"] == "Dawa"

    exact = canon["validation"]["exact_strings"]
    assert exact == ["AvvA", "Av:vA", "<---- AvvA ---->"]
    assert multi["interface_contract"]["persona"] == exact[0]
    assert multi["interface_contract"]["canonical_interface"] == exact[1]
    assert multi["interface_contract"]["environment"] == exact[2]
    assert exact[1] in multi["speakers"]
    assert naming["avva_canon"] == "config/avva-canon.v1.json"
    head = canon["avalhla_head"]
    assert head["kind"] == "cli_coordination_endpoint"
    assert head["is_persona"] is False
    assert head["is_authority"] is False
    assert multi["avalhla_head"]["routes"]["copilot"] == ["Av:vA"]
    assert multi["persona_registry"]["count"] == 7
    assert multi["persona_registry"]["numbered_personas"][-1] == "Dawa 96"

    print("AVVA_CANON_TEST_OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
