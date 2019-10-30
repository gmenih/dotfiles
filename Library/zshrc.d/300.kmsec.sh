# Kube Make Secret
# $1 OR pipe = Secret content
function kmsec() {
    local INPUT=""
    if [ "$#" -eq 0 ]; then
        while read -r line; do INPUT="${INPUT}\n${line}"; done
    else
        INPUT=${1}
    fi

    echo -n "${INPUT}" | base64
}
