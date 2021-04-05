#!/bin/bash

# Generate a random string
# $1 = Length (default=8)
function randstr() {
    LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c ${1:-8}
    echo
}
