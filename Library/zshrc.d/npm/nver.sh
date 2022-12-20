#!/bin/bash 

function nver () {
    npm view $1 versions --json
}
