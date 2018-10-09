#!/bin/bash
run_apt() {
  echo "Installing Packages..."

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt install -y language-pack-ja
  sudo update-locale LANG=ja_JP.UTF-8
  sudo apt update && sudo apt upgrade -y
  [[ $? ]] && scc "Update Packages complete! ✔"

  local list_formulae
  local -a missing_formulae
  local -a desired_formulae=(
    'fish'
    'fonts-powerline'
    'gcc'
    'git'
    'neovim'
    'peco'
    'python3-pip'
    'subversion'
    'tmux'
    'tree'
    'vim'
    'wget'
    'xclip'
  )

  local installed=$(apt list --installed >&1 | grep -v deinstall | awk -F/ '{print $1}')

  for index in ${!desired_formulae[*]}
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      scc "Already installed ${formula} ✔"
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing package formulae..."
    sudo apt install -y $list_formulae

    [[ $? ]] && scc "Installed missing formulae! ✔"
  fi
}
