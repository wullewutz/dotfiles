HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=1000
unsetopt beep
bindkey -v
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

RPROMPT='%F{#504945}%n@%m%f %F{#7c6f64}%~%f'
PROMPT='%F{green}> %f'

