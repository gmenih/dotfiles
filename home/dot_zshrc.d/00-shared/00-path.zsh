# Keep path/fpath deduplicated. oh-my-zsh fingerprints its completion dump with
# the current $fpath and rebuilds from scratch whenever it changes, so a stray
# duplicate entry costs ~400ms on every shell start.
typeset -U path fpath PATH FPATH

export PATH="$PATH:$HOME/.bin:$HOME/.npm-global/bin:$HOME/go/bin"
fpath=(~/.bin $fpath)

# Completion dirs must land in fpath before 00-zsh-config.zsh sources oh-my-zsh,
# which is what runs the single compinit. Prepending them unconditionally here
# (rather than relying on ~/.zprofile, which only login shells read) also pins
# their position, so login and non-login shells produce an identical $fpath and
# share one completion dump.
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[[ -d $HOME/.orbstack/shell/completions/zsh ]] && fpath=($HOME/.orbstack/shell/completions/zsh $fpath)
