#!/bin/zsh

export ZSH="${HOME}/.oh-my-zsh"
export HISTFILESIZE=250000

source "$ZSH/oh-my-zsh.sh"

ZSH_THEME="amuse"

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
