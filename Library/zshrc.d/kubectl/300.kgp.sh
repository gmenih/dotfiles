# Kube Get Pods
function kgp() {
    CMD=$([[ $_ = "--prod" ]] && echo "ktlprod" || echo "ktl") 

    PATTERN=${1}
    REST=${@:2} 
    OUTPUT=$($CMD get po ${REST/--prod/})

    echo $OUTPUT | head -n 1
    echo $OUTPUT | grep $1
}
