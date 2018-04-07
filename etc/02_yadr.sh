#!/bin/bash
# Setup Powerline for Prezto ZSH

# Install YADR
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"

# Enable
echo "prompt powerline" > ~/.zsh.after/prompt.zsh
