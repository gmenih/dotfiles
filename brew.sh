#!/usr/bin/env bash

brew update

brew upgrade

brew tap homebrew/cask

# GNU Utils
brew install coreutils
brew install findutils --with-default-names
brew install grep --with-default-names
brew install gnu-tar
brew install gnupg
brew install openssh
brew install screen

# VIM
brew install vim --with-override-system=vi

# Dev
brew install git
brew install git-crypt
brew install docker docker-compose

# CLI
brew install bat
brew install prettyping
brew install htop
brew install tldr

# OTHER
brew install libpq

# Languages
brew install go
brew install node
brew install python
brew install gradle
brew install kubernetes-coreutils

# Cask
for app in \
    '1password' \
    'aerial' \
    'alfred' \
    'docker' \
    'firefox' \
    'flux' \
    'font-fira-code' \
    'google-chrome' \
    'google-cloud-sdk' \
    'insomnia' \
    'iterm2' \
    'java' \
    'jetbrains-toolbox' \
    'slack' \
    'spotify' \
    'tunnelblick' \
    'visual-studio-code' \
    'vlc' \
    ;do
        brew cask install ${app}
done

brew cleanup
