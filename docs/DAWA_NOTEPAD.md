# DAWA NOTEPAD // THE USER LANE

Dawa <---- AvvA ----> Avalhla

## 01 / WHERE

User files live here:

    /home/VVgbon/Dawa_Notepad

Avalhla's canonical auto-read lane remains:

    /var/home/VVgbon/Avalhla/memory/auto-read

These are two different storage meanings.

## 02 / FLOW

    Dawa_Notepad
        |
        | explicit user choice
        v
    AvvA / bounded crossing
        |
        v
    Avalhla context

Dawa_Notepad is NOT an implicit Avalhla input source.

A file is not read merely because Sublime can display it.

The existing Avalhla auto-read mechanism remains the canonical read door:
    memory/auto-read/
    AVA_AUTOREAD_DIR
    scripts/ava-autoread

Do not create a second Avalhla/read-files directory.

## 03 / AUTHORITY

    DAWA_NOTEPAD
      human-authored material
      notes / drafts / references / scratch work
      USER ONLY

    AVALHLA AUTO-READ
      repository-controlled context material
      intentional bounded ingestion
      AVA OWNED

    AVVA
      relation / living threshold
      NOT a third agent
      NOT authority
      NOT automatic ingestion

CROSS-AVAILABLE != CROSS-CONTAMINATED

## 04 / SUBLIME

The repository stores the machine-readable project template:

    config/sublime/Dawa_Avalhla.sublime-project

The user lane may be absent on a fresh host. The repository does not create
it implicitly. Use the explicit updater when Dawa wants to bootstrap or update
the local project:

    scripts/ava-sublime-update --project

Check both Sublime targets without mutation:

    scripts/ava-sublime-update --check

Update the canonical user settings explicitly:

    scripts/ava-sublime-update --apply

The live user project should be copied into Dawa_Notepad so Sublime's
user-specific workspace/session file stays outside the Avalhla repository.

The explicit updater also handles the copy and parent directory:

    scripts/ava-sublime-update --project

Then open:

    subl /home/VVgbon/Dawa_Notepad/Dawa_Avalhla.sublime-project

The project shows both lanes side-by-side for human access.

Editor visibility is not runtime read authority.

## 05 / STYLE

The machine project deliberately follows Avalhla's existing Sublime contract:

    draw_centered = false
    word_wrap = false
    wrap_width = 80
    ruler = 100
    trim trailing whitespace = false

The existing repository style remains canonical in:

    config/sublime/Preferences.sublime-settings

That file is not replaced by the Dawa project.

The 80-column core plus 100-column frame preserves the terminal/ASCII
geometry already used throughout the repository.

## 06 / MEMORY / READ BOUNDARY

Dawa_Notepad does not become memory merely because a file is interesting.

To cross into Avalhla, use an existing explicit bounded read/ingestion path.

The model sees approved context.
The model does not decide what becomes canonical.

D A W A // V V G B O N
N I G H T 0 W L
A V A L H L A ~ A V A

THE RELATION SURVIVES THE SKIN.
