## dotfiles

Dotfiles for my machines, managed by [Chezmoi](https://chezmoi.io).

Initializing this repository with Chezmoi _should_ install all required packages, set preferred system configs, and provide all of my commonly used zsh functions and scripts, as well as configurations for some of the tools that I use. Since I use both macOS and Linux, a lot contnet is split into `arch` and `darwin`, where `.chezmoiignore` makes sure that only files for the appropriate system are included.

To init, (with Chezmoi installed), run

```bash
chezmoi init --apply gmenih
```

This will pull the repository, execute scripts, and link files into your home directory.

# Contents

The root of the `home` directory contains some common dotfiles for:

-   TMUX
-   ZSH
-   NPM
-   Git
-   ASDF

The rest of the files are spread around different directories.

## .chezmoiscripts

`.chezmoiscripts` is a special folder that contains scripts to execute on init. These scripts will install all required packages (either with `brew` or `yay`), and set some preferred system configs.

## dot_zshrc.d > .zshrc.d

`.zshrc.d` is a configuration directory for ZSH, where I keep all of my helper functions, aliases, and configuration files for ZSH. It includes shared scripts (in `00-shared`, prefixed with 00 for source order), scripts that I only need on macOS (in the `darwin` directory), and scripts I only need on Linux (in the `arch` directory). Each directory contains sub-directories, where the name of the directory represents a command that needs to be present on the system in order for files in the directory to be sourced. E.g. `arch/git/git-alias.zsh` would only be sourced on Linux, if the `git` command is installed.

To see how this works, check out the [.zshrc](home/dot_zshrc.tmpl) file.

## .config

This directory contains configurations for apps that I use. Currently it contains config for:

-   Neovim - this is mostly stolen from [josean](https://github.com/josean-dev/dev-environment-files)
-   [Yabai](https://github.com/koekeishiya/yabai)
-   [SKHD](https://github.com/koekeishiya/skhd)
-   Karabiner

## .chezmoiexternal.toml

This is a special Chezmoi file, which contains config for external dependencies that need to be installed, such as `oh-my-zsh`, `asdf`, and some plugins for these.

## Other

Apart from that, there some less important directories, such as:

-   `Projects` - This is just an empty directory that I want crated, where I store my personal projects.
-   `Work` - same as above, but for work projects
-   `.bin` - contains some executable scripts, and I usuallu put extraneous binaries that I want in my `PATH` variable here.
-   `.npm-global` - a directory that is configured to hold packages installed with `npm install -g`, to avoid user permission issues
