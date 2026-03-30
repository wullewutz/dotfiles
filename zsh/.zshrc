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

# check, whether we are in a WSL environment
if [ -n "$WSL_DISTRO_NAME" ]; then
    # use host's git.exe in wsl prompt to make it fast
    zstyle ':vcs_info:git.exe*' formats '::%b %a %m%u%c '
    zstyle ':vcs_info:git.exe*' check-for-changes true
else
    zstyle ':vcs_info:git*' formats '::%b %a %m%u%c '
    zstyle ':vcs_info:git*' check-for-changes true
fi

RPROMPT='%F{#504945}%n@%m%f'
PROMPT='%F{#7c6f64}%~%f%F{green}${vcs_info_msg_0_}%f
%F{green}> %f'

TERMINAL=alacritty
alias nv=nvim
alias ls=eza\ --git
alias x=xdg-open
alias y=yazi
eval "$(zoxide init zsh)"

if [[ -f ~/.profile ]]; then
  source ~/.profile
fi
