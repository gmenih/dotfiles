#!/bin/bash

# Mass rename files
rename() {
    for i in $1*
    do
        mv "$i" "${i/$1/$2}"
    done
}
