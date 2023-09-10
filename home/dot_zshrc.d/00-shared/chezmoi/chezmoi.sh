#/bin/bash

alias cm="chezmoi"
alias cmu="chezmoi update"
alias cma="chezmoi add"

# ChezMoi File
cmf() {
    set -x
    local file="$1"
    local dir="${2:-00-shared}"
    local ext="${3:-sh}"

    local f="$HOME/.zshrc.d/$dir/$file.$ext"

    "$EDITOR" "$f" && cm add "$f"
}

# ChezMoi Template
cmt () {
    cmf "$1" "$2" "sh.tmpl"
}
