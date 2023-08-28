#!/bin/zsh

alias gpf='ggsup && gp -f'
alias gcane="git commit --amend --no-edit"
alias grom='git rebase origin/$(git_main_branch)'
alias ghom='git reset --hard origin/$(git_main_branch)'
alias gro='git rebase origin/$(git_current_branch)'
alias gho='git reset --hard origin/$(git_current_branch)'
alias grpo='git remote prune origin'
alias gs='git status'
alias ggp='git push'
alias gll='git pull'
alias gcd='git checkout $(git_develop_branch) && git pull'
alias gcm='git checkout $(git_main_branch) && git pull'
alias gcane="git commit --amend --no-edit"
