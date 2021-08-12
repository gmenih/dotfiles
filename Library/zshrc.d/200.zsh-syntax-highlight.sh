#!/bin/zsh

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/bitcomplete bit

. /usr/local/opt/asdf/asdf.sh

. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

###-tns-completion-start-###
if [ -f /Users/gregormenih/.tnsrc ]; then
    source /Users/gregormenih/.tnsrc
fi
###-tns-completion-end-###
