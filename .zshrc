if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=50000

setopt nomatch notify correct extendedhistory incappendhistorytime histreduceblanks histignorespace
unsetopt autocd extendedglob correct_all

zstyle :compinstall filename '/home/artfrowl/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+l:|=* r:|=*'

autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash

export "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=default"
export "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=default"
export "HISTORY_SUBSTRING_SEARCH_PREFIXED=1"
export "HISTORY_SUBSTRING_SEARCH_FUZZY=0"
export "HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
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
bindkey "^[[1;2A" up-line
bindkey "^[[1;2B" down-line
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

alias cp="cp -v -r"
alias mv="mv -v -i"
alias ls="ls -l -h --group-directories-first --color=always"
alias mkdir="mkdir -p -v"
alias grep="grep -i -n -E --color=always"
alias diff="diff -y -N --suppress-common-lines --no-ignore-file-name-case --color=always"
alias mount="mount | column -t"
alias du="du -h"
alias df="df -H"

search() {
    ls -a | \grep -i -E --color="always" "$*"
}

help() {
    "$@" --help 2>&1 | bat -p -l help
}

gitdiff() {
    git diff --name-only --relative "$@" | xargs bat --diff
}

hist() {
    history -Di 0 | \grep -i -E "$*" | bat -l log --pager="less -Ri~ +G"
}
