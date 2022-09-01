if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt nomatch notify
unsetopt autocd extendedglob
bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word
bindkey "^[[1;5D"  backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[Z" reverse-menu-complete

zstyle :compinstall filename '/home/artfrowl/.zshrc'

autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

export "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=default"
export "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=default"
export "HISTORY_SUBSTRING_SEARCH_PREFIXED=1"
export "HISTORY_SUBSTRING_SEARCH_FUZZY=0"
export "HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1"

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
