#!/bin/bash

alias smon='ssh monkey'

function slp() {
    local port=${1:-9000}
    local p2=${2:-"$port"}

    ssh -L "${port}:localhost:${p2}" "monkey"
}

