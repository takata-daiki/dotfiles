#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
for config_file ($HOME/.yadr/zsh/*.zsh) source $config_file

# Powerline
powerline-daemon -q
. /usr/local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

#function zle-line-init zle-keymap-select {
#    VIM_NORMAL="%K{235}%F{208}⮂%k%f%K{208}%F{white} % NORMAL %k%f"
#    VIM_INSERT="%K{235}%F{075}⮂%k%f%K{075}%F{white} % INSERT %k%f"
#    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select
