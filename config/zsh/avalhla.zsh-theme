# SIGNAL: relation first, local working context second. No network or model calls.
setopt PROMPT_SUBST

_avalhla_signal_git() {
    local branch
    branch="$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)" ||
        branch="$(command git rev-parse --short HEAD 2>/dev/null)" || return 0
    branch="${branch//\%/%%}"
    print -rn -- " %F{245}git:(${branch})%f"
}

PROMPT='%F{208}Dawa%f %F{245}<---- AvvA ---->%f %F{39}Avalhla%f
%(?..%F{red}exit %?%f )%F{245}%~%f$(_avalhla_signal_git)
%F{208}>%f '
RPROMPT=''
