#!/bin/bash

function mkb() {
	type="feature/"
	if [[ "$1" = "-b" ]]; then	
		type="bug/"
		shift
	fi

	ticket="PP-$1"
	shift

	rest="$*"
	text=${rest// /-}

	git checkout -b "${type}${ticket}_${text}"
}
	
