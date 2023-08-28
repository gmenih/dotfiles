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
export HISTFILESIZE=250000

# Must be last!
source "$ZSH/oh-my-zsh.sh"
