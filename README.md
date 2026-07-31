# dotfiles

Dotfiles for my machines, managed by [chezmoi](https://chezmoi.io). The repo root is `home/` (via `.chezmoiroot`), which maps onto `$HOME`.

## New machine

1. Restore the age identity from 1Password ("chezmoi age key (identity)") to `~/.config/age-key.txt` - encrypted files cannot decrypt without it.
2. `chezmoi init --apply git@github.com:gmenih/dotfiles.git`

`.chezmoiscripts` runs on init/apply and installs required packages (`brew` on macOS, `yay` on Arch) plus preferred system configs. `.chezmoiexternal.toml` pulls external dependencies like `oh-my-zsh` and its plugins.

## Encryption

This repo is public. Anything work-specific (everything under `.zshrc.d/work/`, work tooling in `.bin`, work-related app configs, the jira claude skills) is age-encrypted - added with `chezmoi add --encrypt`, stored as `encrypted_*.age`. The recipient lives in `.chezmoi.toml.tmpl`; the identity stays out of the repo, backed up in 1Password.

## Contents

### `.zshrc.d`

All ZSH helpers, aliases, and config, sourced by [.zshrc](home/dot_zshrc.tmpl). Split into `00-shared` (everything), `darwin` (macOS only), `arch` (Linux only), and `work` (encrypted). Sub-directories are command-gated: files in `00-shared/docker/` only source when `docker` is installed.

### `.config`

App configs: Ghostty, [herdr](https://herdr.sh) (workspace manager), Neovim, mn (worktree/task tool, built in [monastery](https://github.com/gmenih/monastery)), atuin, starship, yabai, skhd, Karabiner, leader-key, btop, and friends.

### `.claude`

Global instructions (`CLAUDE.md`) and skills for Claude Code. Generic skills (writing, planning, review) are plaintext; work-workflow skills are encrypted.

### `.bin`

Personal scripts and one-off binaries on `PATH`: AWS/ECS helpers, `tuna` (SSO tunnels), `pdb` (encrypted, work database helper), yabai utilities.

### Other

- `Projects` / `Work` - empty directories I want created, for personal and work repos
- `.npm-global` - global npm installs without permission pain
