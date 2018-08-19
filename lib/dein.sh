#!/bin/bash
run_dein() {
  if [ ! -d ${HOME}/.vim/dein ]; then
    pip3 install neovim
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ~/.vim/dein
  fi
}