#!/bin/bash

# Install homebrew
echo "installing homebrew..."
which brew >/dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tap Formulas
brew tap homebrew/binary
brew tap homebrew/dupes
brew tap homebrew/php
brew tap homebrew/versions
brew tap caskroom/cask/brew-cask
brew tap caskroom/fonts
brew tap sanemat/font

# Update homebrew recipes
echo "run brew update..."
brew update

# Install formulas
formulas=(
    colordiff
    coreutils
    ctags
    curl
    gcc
    git
    mas
    postgresql
    python3
    reattach-to-user-namespace
    "ricty --with-powerline"
    screenfetch
    tmux
    tree
    "vim --with-lua"
    wget
    xargs
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)
echo "installing formulas..."
brew install ${formulas[@]}

# Setup ZSH
which -a zsh
sudo -- sh -c 'echo '/usr/local/bin/zsh' >> /etc/shells'
chsh -s /usr/local/bin/zsh

# Install Ricty(font for programming)
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

# Install apps
apps=(
    alfred
    appcleaner
    bettertouchtool
    docker
    dropbox
    google-chrome
    google-japanese-ime
    sourcetree
    virtualbox
)
echo "installing apps..."
brew cask install ${apps[@]}

# Install apps from Mac App Store
# Note: You can get all installed apps by `mas list`
echo "installing Apps from App Store..."
mas install 497799835 # Xcode

# Cleanup homebrew
brew cleanup
brew cask cleanup

echo "DONE! ALL APPLICATIONS INSTALLED!"
