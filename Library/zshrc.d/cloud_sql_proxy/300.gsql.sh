# Open SQL Proxy to Google Cloud
# $1 = Database name
# $2 = Local port (default=5432)
# $3 = Namespace (default=beta-2)
# $4 = Region (default=europe-west1)
function gsql() {
    local PORT=${2:-5432}
    local NAMESPACE=${3:-beta-2}
    local REGION=${4:-europe-west1}
    local NAMESPACE=${5:-$GSQL_PROD_NAMESPACE}

    echo "Opening proxy to ${1} on port ${PORT}\nThis might take a while..."
    cloud_sql_proxy -instances="${NAMESPACE}:${REGION}:tf-${1}-${NAMESPACE}=tcp:${PORT}"
}

function gsqlprod () {
    gsql $1 $2 $3 $5 $GSQL_PROD_NAMESPACE
}
