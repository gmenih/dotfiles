#!/bin/bash


function vpd {
	sudo openvpn --config "$1" --daemon
}
