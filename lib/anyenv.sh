#!/bin/bash
run_anyenv() {
  if [ ! -d ${HOME}/.anyenv ]; then
   git clone https://github.com/riywo/anyenv ${HOME}/.anyenv
   export PATH="${HOME}/.anyenv/bin:${PATH}"
   git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
   anyenv update
   mkdir ${HOME}/.anyenv/envs
   anyenv install goenv
   anyenv install ndenv
   anyenv install pyenv
   anyenv install rbenv
   cat << EOS >> ${HOME}/.bashrc

if [ -d "\$HOME/.anyenv" ]; then
  export PATH="\$HOME/.anyenv/bin:\$PATH"
  eval "\$(anyenv init -)"
fi
EOS
  fi
}
