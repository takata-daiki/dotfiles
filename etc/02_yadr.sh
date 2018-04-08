#!/bin/bash
# Setup Powerline for Prezto ZSH

# Install YADR
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# Install the prompt
curl https://raw.github.com/davidjrice/prezto_powerline/master/prompt_powerline_setup > ~/.zsh.prompts/prompt_powerline_setup

# Enable
echo "prompt powerline" > ~/.zsh.after/prompt.zsh
