#!/bin/bash
run_brew() {
  if has "brew"; then
    echo "$(tput setaf 2)Already installed Homebrew ✔︎$(tput sgr0)"
  else
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if has "brew"; then
    echo "Updating Homebrew..."
    brew update && brew upgrade
    [[ $? ]] && echo "$(tput setaf 2)Update Homebrew complete. ✔︎$(tput sgr0)"

    brew tap 'caskroom/cask'
    brew tap 'caskroom/fonts'
    brew tap 'homebrew/versions'
    brew tap 'homebrew/apache'
    brew tap 'homebrew/dupes'
    brew tap 'sanemat/font'

    local list_formulae
    local -a missing_formulae
    local -a desired_formulae=(
      'coreutils'
      'ctags'
      'fontforge'
      'gcc'
      'gettext'
      'git'
      'openssl'
      'peco'
      'postgresql'
      'python3'
      'reattach-to-user-namespace'
      'svn'
      'tmux'
      'tree'
      'wget'
      'yarn'
      'zsh'
    )

    local installed=`brew list`

    for index in ${!desired_formulae[*]}
    do
      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
      else
        echo "Installed ${formula}"
        [[ "${formula}" = "ricty" ]] && local installed_ricty=true
      fi
    done

    if [[ "$missing_formulae" ]]; then
      list_formulae=$( printf "%s " "${missing_formulae[@]}" )

      echo "Installing missing Homebrew formulae..."
      brew install $list_formulae

      [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
    fi

    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    if [ -z "${installed_ricty}"  ]; then
      echo "Reload fonts. This could take a while..."
      local cellar=`brew --config | grep 'HOMEBREW_CELLAR' | cut -d' ' -f 2`
      find ${cellar}/ricty/*/share/fonts/Ricty*.ttf | xargs -I % cp % ~/Library/Fonts
      fc-cache -vf
    fi

    local -a missing_formulae=()
    local -a desired_formulae=(
      'alfred'
      'bettertouchtool'
      'dropbox'
      'google-chrome'
      'google-japanese-ime'
      'skype'
      'virtualbox'
      'xquartz'
    )
    # cask
    local installed=`brew cask list`

    for index in ${!desired_formulae[*]}
    do
      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
      else
        echo "Installed ${formula}"
      fi
    done

    if [[ "$missing_formulae" ]]; then
      list_formulae=$( printf "%s " "${missing_formulae[@]}" )

      echo "Installing missing Homebrew formulae..."
      brew cask install $list_formulae

      [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
    fi

    echo "Cleanup Homebrew..."
    brew cleanup
    brew cask cleanup
    echo "$(tput setaf 2)Cleanup Homebrew complete. ✔︎$(tput sgr0)"
  fi
}
