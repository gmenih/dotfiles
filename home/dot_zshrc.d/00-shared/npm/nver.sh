#!/bin/bash 

function nver () {
    npm view $1 versions --json
}

function nnver {
    for dep in $(jq -r '.dependencies + .devDependencies | keys[]' package.json); do
	    ver=$(npm view "$dep" "dist-tags.latest")
        echo "\"$dep\": \"$ver\""
    done
}
