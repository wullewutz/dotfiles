HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=1000
unsetopt beep
bindkey -v
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

PROMPT="%K{green}%F{black}%~%f%k %# "
