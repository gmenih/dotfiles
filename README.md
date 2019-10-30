# dotfiles

Some of the things I use.

## Library/zshrc.d

Holds all files that are sourced by `.zshrc`. Files in the root of that directory are sourced immediately, whereas files in subdirectorys are only sourced if the name of the directory is an existing command on the system.

For example, files in `/Library/zshrc.d/git` will only get sourced if `git` is installed.

Inspired by [this article](https://sneak.berlin/20191011/stupid-unix-tricks/).