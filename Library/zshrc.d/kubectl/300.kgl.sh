# Kube Get Logs
# $1 = Service name
function kgl() {
    NAMESPACE="${2:-beta}"
    COMMAND="kubectl -n ${NAMESPACE}"
    REGEX="^${1}-([0-9a-f]{32}|[0-9a-z]{5})\s"

    echo "Fetching pods..."
    OUTPUT=$(eval "${COMMAND} get po" | egrep "${REGEX}")
    POD_NAME=$(echo ${OUTPUT} | awk '{print $1}')

    echo "Found pod ${POD_NAME}"
    if [ $(echo ${OUTPUT} | awk '{split($2,a,"/"); print a[1]}') -eq "2" ]; then
        echo "Getting logs for pod ${POD_NAME}, container ${1}"
        eval "${COMMAND} logs -f ${POD_NAME} ${1}"
        return
    fi
    echo "Getting logs for pod ${POD_NAME}"
    eval "${COMMAND} logs -f ${POD_NAME}"
}
