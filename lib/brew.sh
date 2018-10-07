#!/bin/bash
run_brew() {

  local list_formulae
  local installed
  local -a desired_formulae
  local -a missing_formulae

  if has "brew"; then
    msg "${SKIP} Install Homebrew"
  else
    BREW_INSTALL_MSG="${WARNING} This environment is not installed 'brew'"
    case ${OSTYPE} in
      darwin*)
        msg "${INFO} Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        msg "${SUCCESS} Homebrew is installed!"

        brew tap 'caskroom/cask'
        brew tap 'caskroom/fonts'
        brew tap 'sanemat/font'
        desired_formulae=(
          'coreutils'
          'fish'
          'gcc'
          'gettext'
          'git'
          'reattach-to-user-namespace'
          'ricty --with-powerline'
          'subversion'
          'tmux'
          'tree'
          'wget'
        )
        ;;
      linux*)
        msg "${INFO} Installing Linuxbrew..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
        echo "export PATH=$(brew --prefix)/bin:$(brew --prefix)/.linuxbrew/sbin:$PATH" >> ${HOME}/.bashrc
        sed -i -e 's/LC_ALL="en_US.UTF-8"/LC_ALL="ja_JP.UTF-8"/g' $(brew --prefix)/Library/Homebrew/brew.sh
        brew install hello
        msg "${SUCCESS} Linuxbrew is installed!"

        desired_formulae=(
          'gcc'
          'gettext'
          'git'
          'reattach-to-user-namespace'
          'ricty --with-powerline'
          'subversion'
          'tmux'
          'tree'
          'wget'
        )
        ;;
      *)
        msg "${FAILED} This dotfiles do not support ${OSTYPE}"
        return 0;
        ;;
    esac
  fi

  msg "${INFO} Updating Homebrew..."
  brew update && brew upgrade
  [[ $? ]] && msg "${SUCCESS} Homebrew is updated!"

  installed=`brew list`
  missing_formulae=()

  for index in ${!desired_formulae[*]}
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      msg "${SKIP} Install ${formula}"
      [[ "${formula}" == "ricty --with-powerline" ]] && local installed_ricty=true
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    msg "${INFO} Installing missing Homebrew formulae..."
    brew install $list_formulae

    [[ $? ]] && msg "${SUCCESS} Missing formulae is installed!"
  fi

  # cask
  if [[ ${OSTYPE} == "darwin"* ]]; then
    installed=`brew cask list`
    missing_formulae=()
    desired_formulae=(
      'google-chrome'
      'google-japanese-ime'
    )

    for index in ${!desired_formulae[*]}
    do
      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
      else
        msg "${SKIP} Install ${formula}"
      fi
    done

    if [[ "$missing_formulae" ]]; then
      list_formulae=$( printf "%s " "${missing_formulae[@]}" )

      msg "${INFO} Installing missing Homebrew formulae..."
      brew cask install $list_formulae

      [[ $? ]] && msg "${SUCCESS} Missing formulae is installed!"
    fi
  fi

  #ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
  #ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

  # Ricty
  if [ -z "${installed_ricty}"  ]; then
    msg "${INFO} Reload fonts. This could take a while..."
    #local cellar=`brew --config | grep 'HOMEBREW_CELLAR' | cut -d' ' -f 2`
    local cellar=/usr/local/Cellar
    find ${cellar}/ricty/*/share/fonts/Ricty*.ttf | xargs -I % cp % ~/Library/Fonts
    fc-cache -vf
  fi

  msg "${INFO} Cleanup Homebrew..."
  brew cleanup
  brew cask cleanup
  msg "${SUCCESS} Cleanup Homebrew completed!"
}
