if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=50000

setopt nomatch notify correct extendedhistory incappendhistorytime histreduceblanks histignorespace histfindnodups menucomplete
unsetopt autocd extendedglob correct_all

zstyle ':compinstall' filename '/home/ekunazanu/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*:commands' list-colors '=*=1;32'
zstyle ':completion:*:arguments' list-colors '=*=1;33'
zstyle ':completion:*:parameters' list-colors '=*=1;33'
zstyle ':completion:*:options' list-colors '=*=1;34'
zstyle ':completion:*:zsh-options' list-colors "=*=1;34"

eval "$(dircolors)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word
bindkey "^[[1;5D"  backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[Z" reverse-menu-complete
bindkey "^[[1;5A" up-line
bindkey "^[[1;5B" down-line
bindkey "^[[5~" up-line
bindkey "^[[6~" down-line
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

alias cp="cp -v -r -i"
alias mv="mv -v -i"
alias rm="rm -r -i"
alias ls="ls -l -h --group-directories-first --color=always"
alias tree="tree -C --dirsfirst"
alias mkdir="mkdir -p -v"
alias grep="grep -i -n -E --color=always"
alias diff="diff -y -N --suppress-common-lines --no-ignore-file-name-case --color=always"
alias mount="mount | column -t"
alias du="du -h"
alias df="df -H"
alias tt="taskwarrior-tui"
alias cat="bat"

function search {
    ls -a | \grep -i -E --color="always" "$*"
}

function help {
    "$@" --help 2>&1 | bat -p -l help
}

function gitdiff {
    git diff --name-only --relative "$@" | xargs bat --diff
}

function hist {
    history -Di 0 | \grep -i -E "$*" | bat -l log --pager="less -Ri~ +G"
}

function preexec() {
    print -Pn "\e]0;${(q)1}\e\\"
}
