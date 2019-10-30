# Kube Get Secret
# $1 = Secret name
# $2 = Secret key (optional)
# $3/$2 = Namespace
function kgs() {
    NAMESPACE=${3:-${2:-beta}}
    COMMAND="kubectl -n ${NAMESPACE}"

    if [ "$#" -eq "2" ]; then
        OUTPUT="$(eval ${COMMAND} get secret $1 -o=jsonpath="{.data.\"$2\"}" | base64 --decode)"
    elif [ "$#" -eq "1" ]; then
        OUTPUT="$(eval ${COMMAND} get secret $1 -o=json)"
    fi
    echo "${OUTPUT}"
}
