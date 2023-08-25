#!/usr/bin/env bash

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install OhMyZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Make .bin folder in home dir and cd there
mkdir ${HOME}/.bin && cd "$_"

# Download clous_sql_proxy and make it executable
curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x cloud_sql_proxy

# Sync zsh
rsync -avh --no-perms --exclude "bootstrap.sh" --exclude "brew.sh" --exclude "macos.sh". ~

source ~/.zshrc

# Install everything from brew
./brew.sh

# Config Macos
./macos.sh
