#!/bin/bash
run_tpm() {
  [ ! -d ${HOME}/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
  cat << EOS >> ${HOME}/.bashrc

if [ ! -n \${TMUX} ]; then
  tmux new-session
fi
EOS
}
