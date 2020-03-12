function ktllog () {
    local LOG_REQ=${2:-10}
    echo "logs --selector app=$1 --container=$1 -f --max-log-requests=$LOG_REQ"
}

function ktllegacy () {
    local LOG_REQ=${2:-10}
    echo "logs --selector role=$1 --container=$1 -f --max-log-requests=$LOG_REQ"
}

# Kube Get Logs
# $1 = Service name
function kgl() {
    CMD=$([[ $_ = "--prod" ]] && echo "ktlprod" || echo "ktl")
    $CMD $(ktllog $1) 
}

# Kube Get Logs (Legacy)
function kgll() {
    CMD=$([[ $_ = "--prod" ]] && echo "ktlprod" || echo "ktl")
    $CMD $(ktllegacy $1)
}
