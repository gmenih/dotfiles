# Kube Get Secret
function kgs() {
    CMD=$([[ $_ = "--prod" ]] && echo "ktlprod" || echo "ktl")

    if [ "$#" -eq "2" ]; then
        OUTPUT="$(eval ${CMD} get secret $1 -o=jsonpath="{.data.\"$2\"}" | base64 --decode)"
    elif [ "$#" -eq "1" ]; then
        OUTPUT="$(eval ${CMD} get secret $1 -o=json)"
    fi
    echo "${OUTPUT}"
}
