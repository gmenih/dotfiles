#!/bin/bash

function vpa {
	cd "$HOME/Work/povio/arena/client-config"
	sudo openvpn --config "$1.ovpn" --daemon
    cd -
}
