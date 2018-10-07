#!/bin/bash
run_brew() {
  if has "brew"; then
    msg "${INFO} Updating Homebrew..."
    brew update && brew upgrade
    [[ $? ]] && msg "${SUCCESS} Homebrew is updated!"

    if [[ ${OSTYPE} == "darwin"* ]]; then
      brew tap 'caskroom/cask'
      brew tap 'caskroom/fonts'
      brew tap 'sanemat/font'
    fi

    local list_formulae
    local -a missing_formulae
    local -a desired_formulae=(
      'coreutils'
      'gcc'
      'gettext'
      'git'
      'python3'
      'reattach-to-user-namespace'
      'ricty --with-powerline'
      'tmux'
      'tree'
      'wget'
      '--without-etcdir zsh'
      'zsh-completions'
      'screenfetch'
    )

    local installed=`brew list`

    for index in ${!desired_formulae[*]}
    do
      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
      else
        echo "Installed ${formula}"
        [[ "${formula}" = "ricty --with-powerline" ]] && local installed_ricty=true
      fi
    done

    if [[ "$missing_formulae" ]]; then
      list_formulae=$( printf "%s " "${missing_formulae[@]}" )

      echo "Installing missing Homebrew formulae..."
      brew install $list_formulae

      [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
    fi

    #ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    #ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    if [ -z "${installed_ricty}"  ]; then
      echo "Reload fonts. This could take a while..."
      #local cellar=`brew --config | grep 'HOMEBREW_CELLAR' | cut -d' ' -f 2`
      local cellar=/usr/local/Cellar
      find ${cellar}/ricty/*/share/fonts/Ricty*.ttf | xargs -I % cp % ~/Library/Fonts
      fc-cache -vf
    fi

    local -a missing_formulae=()
    local -a desired_formulae=(
      'google-chrome'
      'google-japanese-ime'
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
