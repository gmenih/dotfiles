#!/bin/zsh

# Settings
export DISABLE_UPDATE_PROMPT=true

plugins=(
    git
    docker
    asdf
    1password
    aws
    npm
)

export ZSH="${HOME}/.oh-my-zsh"
export ZSR="$HOME/.zshrc.d"
export HISTFILESIZE=250000

# Must be last!
source "$ZSH/oh-my-zsh.sh"
