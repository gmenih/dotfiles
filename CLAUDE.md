# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed by [Chezmoi](https://chezmoi.io). The repository root is set to `home/` via `.chezmoiroot`, meaning all files in the `home/` directory will be deployed to `$HOME` on the target system.

## Chezmoi Commands

```bash
# Apply dotfiles to the system
chezmoi apply

# See what changes would be made without applying them
chezmoi diff

# Edit a dotfile in its source location
chezmoi edit <file>

# Add a new file to chezmoi management
chezmoi add <file>

# Update the source directory from the target system
chezmoi update

# Re-run scripts (useful after modifying .chezmoiscripts)
chezmoi apply --force
```

## Architecture

### Directory Structure

- `home/` - Root directory that maps to `$HOME` on target systems
- `home/.chezmoiscripts/` - Install scripts that run on `chezmoi init` or `chezmoi apply`
  - `darwin/` - macOS-specific scripts (brew installs, system config)
  - `arch/` - Arch Linux-specific scripts (yay/pacman installs)
  - `run_once_*` - Scripts that run only once (tracked by Chezmoi state)
- `home/dot_zshrc.d/` - Modular ZSH configuration split by platform and command availability
  - `00-shared/` - Common configs sourced on all systems
  - `darwin/` - macOS-specific ZSH configs
  - `arch/` - Arch Linux-specific ZSH configs
  - `work/` - Work-specific configs
- `home/private_dot_config/` - Application configs (nvim, tmux, git, yabai, skhd, karabiner, etc.)

### Chezmoi Templates

Files ending in `.tmpl` are Go templates processed by Chezmoi. They have access to:
- `.chezmoi.os` - Operating system (darwin, linux)
- `.chezmoi.hostname` - System hostname
- `.chezmoi.homeDir` - User's home directory
- Custom variables from `.chezmoi.toml.tmpl` like `.isMac`, `.isArch`, `.npmToken`, etc.
- Functions like `lookPath`, `onepasswordRead`, `glob`, `splitList`

### ZSH Configuration Logic

The `.zshrc` template uses Chezmoi's Go templating to conditionally source files from `.zshrc.d/`:
- Files in subdirectories 3+ levels deep only source if the parent directory name matches an available command
- Example: `.zshrc.d/00-shared/docker/alias.sh` only sources if `docker` is in PATH
- This allows command-specific configs to be automatically enabled/disabled based on what's installed

### Platform-Specific Behavior

The `.chezmoiignore.tmpl` file excludes platform-specific directories based on OS:
- On non-Arch Linux systems, `arch/` directories are ignored
- On non-macOS systems, `darwin/` directories and macOS-specific files (yabai, skhd) are ignored

### Secret Management

No secrets are currently loaded - AI/API keys were deliberately removed from the environment (2026-07). If a secret is ever needed again, load it via 1Password CLI (`onepasswordRead`) in `.chezmoi.toml.tmpl` and expose it to templates as a `[data]` variable; never hardcode values in templates.

### Work files are encrypted (this repo is PUBLIC)

Anything work-specific - everything under `.zshrc.d/work/`, work tooling in `.bin` (e.g. `pdb`), per-repo mn configs for work repos - MUST be added with `chezmoi add --encrypt`, never plaintext. Age recipient lives in `.chezmoi.toml.tmpl`; the identity is `~/.config/age-key.txt` (untracked, backed up in 1Password as "chezmoi age key (identity)"). If that identity file is missing on a machine, restore it from 1Password before `chezmoi apply` - encrypted files cannot decrypt without it.

## Important Notes

- When modifying install scripts in `.chezmoiscripts/`, use `chezmoi apply --force` to re-run them
- Changes to `.chezmoiignore.tmpl` or `.chezmoi.toml.tmpl` require understanding Go template syntax
- The repository uses Age encryption for sensitive files (recipient configured in `.chezmoi.toml.tmpl`)
- External dependencies (like oh-my-zsh, tpm) are managed via `.chezmoiexternal.toml`
