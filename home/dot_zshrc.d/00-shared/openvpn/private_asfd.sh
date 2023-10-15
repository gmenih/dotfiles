#!/bin/bash

function vpa {
	cd "$HOME/.vpn"
	sudo openvpn --config "$1.ovpn" --daemon
    cd -
}
