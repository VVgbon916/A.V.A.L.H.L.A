# DAWA NOTEPAD // SYNCABLE USER LANE

Dawa <---- AvvA ----> Avalhla

## 01 / WHERE

The Dawa user lane now lives inside the canonical repository:

    /var/home/VVgbon/Avalhla/Dawa_Notepad

Avalhla's canonical auto-read lane remains separate:

    /var/home/VVgbon/Avalhla/memory/auto-read

These have different meanings.

Dawa_Notepad is tracked and can be refreshed by Git sync.
Dawa_Notepad is NOT implicit Avalhla model input.

## 02 / SYNC MEANING

This directory is intentionally part of the repository because Dawa wants
selected user material to travel with Avalhla's source and be refreshable
through Git.

Tracked does not mean trusted.
Tracked does not mean auto-read.
Tracked does not mean model input.

Dawa explicitly chooses what crosses into Avalhla context.

## 03 / PUBLIC REPOSITORY WARNING

The GitHub repository is public.

Anything committed under Dawa_Notepad is repository content and can be visible
on GitHub and retained in Git history.

Do not store:

    passwords
    API keys
    access tokens
    private keys
    credentials
    private-only personal material

Local-only escape hatch:

    Dawa_Notepad/private/

That path is ignored by Git and must never be force-added.

## 04 / SUBLIME

The canonical project file lives inside this lane:

    Dawa_Notepad/Dawa_Avalhla.sublime-project

Its folders are relative to the project directory:

    .
      Dawa_Notepad

    ../memory/auto-read
      Avalhla canonical auto-read

Sublime supports relative project folder paths and recommends keeping the
.sublime-project under version control while the user-specific
.sublime-workspace remains separate.

Open:

    subl /var/home/VVgbon/Avalhla/Dawa_Notepad/Dawa_Avalhla.sublime-project

The workspace remains local and is ignored:

    *.sublime-workspace

## 05 / SETTINGS

Global Sublime user settings remain canonical in:

    config/sublime/Preferences.sublime-settings

Refresh those settings explicitly:

    scripts/ava-sublime-update --apply

Check:

    scripts/ava-sublime-update --check
    scripts/ava-sublime-update --paths

Repository sync refreshes the Dawa project:

    git fetch origin --prune
    git merge --ff-only origin/change/avva-relational-signature-2026-09-27

## 06 / BOUNDARY

    SYNCABLE != AUTO-READ
    TRACKED != MODEL-INPUT
    EDITOR VISIBILITY != INGESTION AUTHORITY
    CROSS-AVAILABLE != CROSS-CONTAMINATED

Dawa chooses what crosses the relation.

THE RELATION SURVIVES THE SKIN.
