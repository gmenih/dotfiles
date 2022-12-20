#!/bin/zsh

alias gpf='ggsup && gp -f'
alias grom='git reset --hard origin/master'
alias grpo='git remote prune origin'
alias gs='git status'
alias gll='git pull'
alias gcd='git checkout $(git_develop_branch) && git pull'
alias gcm='git checkout $(git_main_branch) && git pull'
