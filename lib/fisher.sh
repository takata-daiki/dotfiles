#!/bin/bash
run_fisher() {
  if [ ! -d ${HOME}/.config/fish/functions/fisher.fish ]; then
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
  fi

  cat << EOS >> ${HOME}/.config/fish/fishfile
0rax/fish-bd
edc/bass
fisherman/fzf
fisherman/z
oh-my-fish/peco
oh-my-fish/plugin-expand
oh-my-fish/theme-bobthefish
EOS

  cat << EOS >> ${HOME}/.config/fish/config.fish
# turn on vi mode when the shell starts
fish_vi_key_bindings
fish_vi_cursor

# bind for peco history to ? in normal mode
function fish_user_key_bindings
  bind \\? peco_select_history
end

# bootstrap installation
if not functions -q fisher
  echo "Installing fisher for the first time..." >&2
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo \$XDG_CONFIG_HOME/fish/functions/fisher.fish
  fisher
end
EOS

  exec ${SHELL} -l
  fisher
}
