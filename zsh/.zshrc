# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=4000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/wullewutz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Only load Liquid Prompt in interactive shells, not from a script or from scp
[[ $- = *i* ]] && source liquidprompt
