#!/usr/bin/env bash

brew update

brew upgrade

# GNU Utils
brew install coreutils
brew install findutils --with-default-names
brew install grep --with-default-names
brew install gnu-tar
brew install gnupg
brew install openssh
brew install screen

# Dev
brew install docker docker-compose

# CLI
brew install bat
brew install prettyping
brew install btpo
brew install tldr

# OTHER
brew install libpq

# Languages
brew install go

# 
for app in \
    '1password' \
    'docker' \
    'firefox' \
    'flux' \
    'font-fira-code' \
    'google-chrome' \
    'iterm2' \
    'java' \
    'slack' \
    'spotify' \
    'tunnelblick' \
    'visual-studio-code' \
    'vlc' \
    ;do
        brew install ${app}
done

brew cleanup
