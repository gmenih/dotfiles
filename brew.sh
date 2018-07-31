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
    'alfred' \
    'flux' \
    'google-cloud-sdk' \
    'google-chrome' \
    'insomnia' \
    'spotify' \
    'vlc' \
    'aerial' \
    'firefox' \
    'font-fira-code' \
    'iterm2' \
    'slack' \
    'tunnelblick' \
    'visual-studio-code' \
    'java' \
    'jetbrains-toolbox' \
    ;do
        brew cask install ${app}
done

brew cleanup