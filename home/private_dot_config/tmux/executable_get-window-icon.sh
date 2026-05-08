#!/usr/bin/env bash
# Maps window names and commands to Nerd Font icons

cmd="${1,,}"  # Convert to lowercase

# Check command name patterns
case "$cmd" in
    # Editors
    *nvim*|*neovim*) printf '\ue62b' ;;
    *vim*|*vi*) printf '\ue62b' ;;
    *emacs*) printf '\ue632' ;;
    *code*|*vscode*) printf '\uf1fa' ;;
    
    # Shells
    *zsh*) printf '\uf489' ;;
    *bash*) printf '\ue795' ;;
    *fish*) printf '\uf739' ;;
    *sh) printf '\uf489' ;;
    
    # Development
    *node*|*npm*|*yarn*) printf '\ue718' ;;
    *python*|*py) printf '\ue73c' ;;
    *ruby*|*irb*) printf '\ue791' ;;
    *go*) printf '\ue627' ;;
    *rust*|*cargo*) printf '\ue7a8' ;;
    *docker*) printf '\uf308' ;;
    *kubernetes*|*kubectl*|*k9s*) printf '\ue702' ;;
    
    # Git
    *git*|*lazygit*|*tig*) printf '\ue702' ;;
    *github*|*gh) printf '\uf408' ;;
    
    # Databases
    *psql*|*postgres*) printf '\ue76e' ;;
    *mysql*|*mariadb*) printf '\ue704' ;;
    *mongo*) printf '\ue703' ;;
    *redis*) printf '\ue76d' ;;
    
    # System tools
    *htop*|*top*|*btop*) printf '\uf85a' ;;
    *ssh*) printf '\uf489' ;;
    *ranger*|*lf*|*nnn*) printf '\uf07c' ;;
    
    # Other
    *tmux*) printf '\uf489' ;;
    *music*|*spotify*) printf '\uf1bc' ;;
    
    # Default
    *) printf '\uf489' ;;
esac
