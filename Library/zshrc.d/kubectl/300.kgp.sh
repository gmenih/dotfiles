# Kube Get Pods
# $1 = Grep input to find pods by
# $2 = Namespace
function kgp() {
    NAMESPACE=${2:-beta}
    COMMAND="kubectl -n ${NAMESPACE}"

    if [ "$#" -ne "1" ]; then
        echo "Usage: kgp <service-name>"
        return 1
    fi

    eval "${COMMAND} get po" | grep "${1}"
}
