HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=1000
KEYTIMEOUT=5
unsetopt beep
setopt prompt_subst
bindkey -v
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# setup git prompt support
autoload -Uz vcs_info
precmd() {
    vcs_info
}
zstyle ':vcs_info:git*' formats '::%b %a %m%u%c '
zstyle ':vcs_info:git*' check-for-changes true

RPROMPT='%F{#504945}%n@%m%f'
PROMPT='%F{#7c6f64}%~%f%F{green}${vcs_info_msg_0_}%f 
%F{green}> %f'

TERMINAL=alacritty
alias jo=joshuto
alias nv=nvim
alias ls=exa\ --git
alias x=xdg-open
