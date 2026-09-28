# DAWA NOTEPAD // SYNCABLE USER LANE

Dawa <---- AvvA ----> Avalhla

This directory is inside the Avalhla repository by deliberate choice.

## 01 / MEANING

    Dawa_Notepad/
      DAWA / SYNCABLE USER LANE

    memory/auto-read/
      AVALHLA / AUTO-READ LANE

Dawa_Notepad is tracked by Git and can be refreshed by repository sync.

Dawa_Notepad is NOT implicit Avalhla model input.

A file is not read by Avalhla merely because it is tracked, visible in Git,
or visible in Sublime.

Explicit user-directed crossing is still required.

## 02 / PUBLIC SYNC WARNING

This repository is public.

Anything committed under Dawa_Notepad can be published to GitHub and retained
in repository history. Do not store passwords, tokens, private keys, secrets,
or material that should remain private.

For local-only material use:

    Dawa_Notepad/private/

That path is ignored by Git and must never be force-added.

Git sync is for material Dawa intentionally chooses to publish and preserve.

## 03 / SUBLIME

The canonical project lives beside this file:

    Dawa_Notepad/Dawa_Avalhla.sublime-project

Its first folder is this directory.
Its second folder is Avalhla's canonical:

    ../memory/auto-read/

Sublime supports relative project folder paths, and the project definition can
be checked into version control while the generated workspace remains separate.

Open with:

    subl /var/home/VVgbon/Avalhla/Dawa_Notepad/Dawa_Avalhla.sublime-project

The workspace file remains local:

    *.sublime-workspace

## 04 / SETTINGS

Global Sublime user settings remain canonical in:

    config/sublime/Preferences.sublime-settings

Refresh them explicitly with:

    scripts/ava-sublime-update --apply

Check settings and project state with:

    scripts/ava-sublime-update --check

Project refresh is repository sync:

    git fetch origin --prune
    git merge --ff-only origin/change/avva-relational-signature-2026-09-27

## 05 / BOUNDARY

    SYNCABLE != AUTO-READ

    TRACKED != MODEL-INPUT

    EDITOR VISIBILITY != INGESTION AUTHORITY

    CROSS-AVAILABLE != CROSS-CONTAMINATED

Dawa chooses what crosses the relation.

THE RELATION SURVIVES THE SKIN.
