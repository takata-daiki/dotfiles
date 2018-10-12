#!/bin/bash
run_brew() {

  if has "brew"; then
    scc "Already installed Homebrew ✔"
  else
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # update
  echo "Updating brew..."
  brew update && brew upgrade
  [[ $? ]] && scc "Update Homebrew completed! ✔"

  # tap
  brew tap 'caskroom/cask'
  brew tap 'caskroom/fonts'
  brew tap 'sanemat/font'

  # install
  local installed=`brew list`
  local list_formulae
  local -a missing_formulae=()
  local -a desired_formulae=(
    'coreutils'
    'fish'
    'gcc'
    'git'
    'neovim'
    'peco'
    'reattach-to-user-namespace'
    'ricty --with-powerline'
    'subversion'
    'tmux'
    'tree'
    'vim'
    'wget'
  )

  for index in "${!desired_formulae[@]}"
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      scc "Already installed ${formula} ✔"
      [[ "${formula}" == "ricty --with-powerline" ]] && local installed_ricty=true
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )
    echo "Installing missing brew formulae..."
    brew install $list_formulae
    [[ $? ]] && scc "Install missing formulae completed! ✔"
  fi

  # ricty
  if [ -z "${installed_ricty}"  ]; then
    echo "Reload fonts. This could take a while..."
    local cellar=/usr/local/Cellar
    find ${cellar}/ricty/*/share/fonts/Ricty*.ttf | xargs -I % cp % ~/Library/Fonts
    fc-cache -vf
  fi

  # cask install
  local installed=`brew cask list`
  local -a missing_formulae=()
  local -a desired_formulae=(
    'docker'
    'dropbox'
    'google-chrome'
    'google-japanese-ime'
    'vagrant'
    'virtualbox'
    'xquartz'
  )

  for index in "${!desired_formulae[@]}"
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
    echo "Installing missing Homebrew formulae..."
    brew cask install $list_formulae
    [[ $? ]] && scc "Install missing formulae completed! ✔"
  fi

  # cleanup
  echo "Cleanup Homebrew..."
  brew cleanup
  scc "Cleanup Homebrew completed! ✔"
}
