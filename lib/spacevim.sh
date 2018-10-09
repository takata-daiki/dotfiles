#!/bin/bash
run_spacevim() {
  curl -sLf https://spacevim.org/install.sh | bash
  pip3 install neovim --upgrade
}
