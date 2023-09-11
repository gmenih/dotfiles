#!/bin/zsh

# Settings
ZSH_THEME="gamuze"

plugins=(
    git
    docker
    ag
    asdf
    1password
    aws
    fd
    npm
)

export ZSH="${HOME}/.oh-my-zsh"
export ZSR="$HOME/.zshrc.d"
export HISTFILESIZE=250000
export DISABLE_UPDATE_PROMPT=true

# Must be last!
source "$ZSH/oh-my-zsh.sh"
