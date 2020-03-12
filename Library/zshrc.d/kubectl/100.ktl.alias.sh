function ktl () {
    kubectl --context="${DEV_KUBERNETES_CONTEXT}" -n="${DEV_KUBERNETES_NAMESPACE}" "${@}"
}
