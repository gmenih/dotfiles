#!/usr/bin/env bash

git pull origin master

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install OhMyZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Make .bin folder in home dir and cd there
mkdir ${HOME}/.bin && cd "$_"
curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x cloud_sql_proxy

# Sync zsh
rsync 
    -avh --no-perms ./zsh ~;
source ~/.zshrc

# Install everything from brew
./brew.sh

# Configure macos
./macos.sh
