function ktlprod () {
    kubectl --context="${PROD_KUBERNETES_CONTEXT}" -n="${PROD_KUBERNETES_NAMESPACE}" "${@}"
}
