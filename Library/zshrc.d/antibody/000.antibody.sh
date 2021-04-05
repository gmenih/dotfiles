source <(antibody init)

local packages=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zdharma/fast-syntax-highlighting
    wookayin/anybar-zsh
)

for package in $packages; do
    antibody bundle $package
done
