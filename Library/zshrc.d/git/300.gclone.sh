function gclone() {
    if [ "$#" -eq "1" ]; then
        git clone "${1}"
        return
    fi
    git clone "git@github.com:${1}/${2}.git"
}
