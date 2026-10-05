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
  3.1 Private Dawa repository
      VVgbon916/Dawa_Notepad
      /var/home/VVgbon/Dawa_Notepad
      private human lane; not implicit model input
  3.2 Avalhla auto-read
      /var/home/VVgbon/Avalhla/memory/auto-read
      canonical bounded read lane
  3.3 Sublime project
      /var/home/VVgbon/Dawa_Notepad/Dawa_Avalhla.sublime-project
      private editor project; workspace/session state stays ignored

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
      explicit host-side Sublime user-settings updater only

05 CHANGE LOOP
  READ -> REAL STATE -> UNDERSTAND -> COMPARE -> CROSS-CHECK
  -> MINIMAL EDIT -> POSITIVE TEST -> NEGATIVE TEST
  -> VERIFY -> DEVILASH ATTACK -> DIFF -> REVIEW -> DAWA HUMAN GATE

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
      VERIFY -> DEVILASH ATTACK -> DIFF -> REVIEW
  7.2 Human gate
      Dawa explicitly approves consequential Git actions
  7.3 Integration gate
      COMMIT -> PUSH -> REMOTE CONFIRM

No blind staging. No silent phase advancement.

### SIGNAL shell theme

The canonical theme source is `config/zsh/avalhla.zsh-theme`. Its signature is
exactly `Dawa <---- AvvA ----> Avalhla`, without a face suffix. Orange Dawa,
neutral AvvA, and blue Avalhla are presentation only, not status or authority.
The second line shows the local path, Git branch (or detached HEAD), and
nonzero exit status. The third line accepts commands. No clock or mood dot is
added, and the theme makes no model or network calls.

Install a copy at `${ZSH_CUSTOM:-$ZSH/custom}/themes/avalhla.zsh-theme` and source
it as shown in `config/zshrc.example`. Back up shell settings before replacing
only the old prompt definition, not the whole `.zshrc`. Existing terminal-title
behavior can remain independent. Reload with `source ~/.zshrc`.

The chat Modelfile source uses the same plain signature. Editing it does not
rebuild or activate an installed Ollama model.

## 08 / TOOLS, COSTS, AND HARDWARE

```text
LOCAL TOOLS      -> installed runtime + available resources
REMOTE SERVICES -> account permissions + provider limits
REVIEW          -> evidence, not an automatic merge
HARDWARE        -> measured compatibility, not a promise
```

Git and GitHub tooling support source control. Ollama is part of the documented
local model setup. CodeRabbit and Devin are external evidence witnesses, not
owners of the repository or guarantees of security.

Local inference still consumes memory, compute, storage, power, and maintenance.
Remote plans can impose charges, quotas, and concurrency limits. No fixed
subscription price, token allowance, free-worker multiplier, or performance
figure is established by this document.

Before selecting a model or buying hardware, record:

- Model and quantization, context size, and intended workload.
- Available RAM/VRAM, storage, and supported execution environment.
- Observed latency and resource use under that workload.
- Current provider terms and a deliberate spending/concurrency limit.

Raspberry Pi computers, embedded boards, cameras, and displays are possible
future exploration targets, not an approved shopping list or delivery schedule.
Compatibility with a desktop image or a model must be checked for the exact
device. Do not infer privacy, immunity to malware, or acceptable performance
from the hardware brand or an immutable operating system.

Product discovery links, not compatibility evidence:

- [Raspberry Pi products](https://www.raspberrypi.com/products/)
- [Cameras and displays](https://www.raspberrypi.com/products/#cameras-and-displays)
- [Bazzite](https://bazzite.gg/)

Personal budgets, gifts, recipient details, and private purchasing plans belong
in Dawa's private repository, not in this public development contract.
