# Avalhla Development

01 WHERE
  1.1 Canonical repo
      /var/home/VVgbon/Avalhla
  1.2 Canonical memory
      /var/home/VVgbon/Avalhla/memory
  1.3 Host
      Bazzite / Kinoite-style immutable desktop

02 EXECUTION CONTEXT
  2.1 Ollama
      user Podman container + systemd user service
  2.2 Development
      Distrobox is a development environment, not the owner
      of Avalhla's canonical source tree
  2.3 Host packages
      Prefer existing Bazzite tooling and Distrobox.
      Do not use random sudo dnf/apt/pacman installs on the immutable host.

03 EDITOR / HUMAN LANE
  3.1 Dawa_Notepad
      /home/VVgbon/Dawa_Notepad
      user-only authored material; not implicit Avalhla context
  3.2 Avalhla auto-read
      /var/home/VVgbon/Avalhla/memory/auto-read
      canonical bounded read lane
  3.3 Sublime template
      config/sublime/Dawa_Avalhla.sublime-project
      two visible roots; workspace/session state stays outside the repo

04 TOOLCHAIN WITNESSES
  4.1 git / gh
      source control and GitHub sync
  4.2 rg
      reference search before rename
  4.3 shellcheck
      shell quality check
  4.4 realpath
      path-resolution witness
  4.5 ava-sublime-update
      explicit host-side Sublime settings + Dawa user project sync

05 CHANGE LOOP
  READ -> REAL STATE -> UNDERSTAND -> COMPARE -> CROSS-CHECK
  -> MINIMAL EDIT -> TEST -> VERIFY -> DIFF -> REVIEW

06 SAFETY
  6.1 Runtime authority
      lib_runtime.sh
  6.2 Safety authority
      lib_safety.sh
  6.3 Context authority
      lib_context.sh
  6.4 Model authority
      model sees approved inputs; model does not self-authorize

07 GIT
  7.1 Review gate
      VERIFY -> DIFF -> REVIEW
  7.2 Integration gate
      COMMIT -> PUSH -> REMOTE CONFIRM

No blind staging. No silent phase advancement.
