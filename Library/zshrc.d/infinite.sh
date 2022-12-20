#! /bin/bash

function infinite {
	while true; do "$@" && break; done
}
