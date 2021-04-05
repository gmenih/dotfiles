#!/bin/bash

# Make Branch
function mbr() {
    git switch -c "$([[ $_ = '--bug' ]] && 'bug' || 'feature')/DEV-$1_$(echo $2 | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\L\2/g')"
}
