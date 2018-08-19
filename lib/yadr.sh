#!/bin/bash
run_yadr() {
  if [ ! -d ${HOME}/.yadr ]; then
    sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
    curl https://raw.github.com/davidjrice/prezto_powerline/master/prompt_powerline_setup > ~/.zsh.prompts/prompt_powerline_setup
    echo "prompt powerline" > ~/.zsh.after/prompt.zsh
    echo "screenfetch -E" > ~/.zsh.after/prompt.zsh
  else
    cd ${HOME}/.yadr
    git pull --rebase
    rake update
  fi
}