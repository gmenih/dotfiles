# Kube Read Secret
# $1 OR pipe = Secret content
function krsec() {
    local INPUT=""
    if [ "$#" -eq 0 ]; then
        while read -r line; do INPUT="${INPUT}\n${line}"; done
    else
        INPUT=${1}
    fi
    echo "${INPUT}" | base64 --decode
}
