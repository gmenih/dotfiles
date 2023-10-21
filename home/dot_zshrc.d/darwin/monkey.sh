#!/bin/bash

alias smon='ssh monkey'

# Forward Ports Monkey
# Forwards ports I commonly use via SSH tunnel,
# and connects to `monkey` so that I can do my
# development there
function fpm() {
  local default_ports=(8000 8080 3000 4321 9000)
  local all_ports=("${default_ports[@]}" "$@")
  local ssh_command="ssh"

  for port in "${all_ports[@]}"; do
    ssh_command+=" -L ${port}:localhost:${port}"
  done

  ssh_command+=" monkey"
  eval "$ssh_command"
}

