#!/bin/bash
run_brew() {

  if has "brew"; then
    scc "Already installed Homebrew ✔"
  else
    BREW_INSTALL_MSG="${WARNING} This environment is not installed 'brew'"
    case ${OSTYPE} in
      darwin*)
        echo "Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        brew tap 'caskroom/cask'
        brew tap 'caskroom/fonts'
        brew tap 'sanemat/font'
        local -a desired_formulae=(
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
          'vim'
          'wget'
        )
        ;;

      linux*)
        echo "Installing Linuxbrew..."
        git clone https://github.com/Linuxbrew/brew.git ${HOME}/.linuxbrew
        export PATH=${HOME}/.linuxbrew/bin:${PATH}
        echo "export PATH=${PATH}" >> ${HOME}/.bashrc
        echo "export MANPATH=${HOME}/.linuxbrew/share/man:${MANPATH}" >> ${HOME}/.bashrc
        echo "export INFOPATH=${HOME}/.linuxbrew/share/info:${INFOPATH}" >> ${HOME}/.bashrc

        sed -i -e 's/LC_ALL="en_US.UTF-8"/LC_ALL="ja_JP.UTF-8"/g' $(brew --prefix)/Library/Homebrew/brew.sh

        brew tap 'sanemat/font'
        local -a desired_formulae=(
          'fish'
          # 'gcc'
          # 'gettext'
          # 'git'
          # 'reattach-to-user-namespace'
          # 'ricty --with-powerline'
          # 'subversion'
          # 'tmux'
          # 'tree'
          # 'vim'
          # 'wget'
        )
        ;;

      *)
        err "Working only OSX / Ubuntu!!"
        return 0;
        ;;
    esac
  fi

  echo "Updating brew..."
  brew update && brew upgrade

  local installed=`brew list`
  local -a missing_formulae=()

  for index in "${!desired_formulae[@]}"
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      scc "Already installed ${formula}"
      [[ "${formula}" == "ricty --with-powerline" ]] && local installed_ricty=true
    fi
  done


  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )
    echo "Installing missing brew formulae..."
    brew install $list_formulae
    [[ $? ]] && scc "Install missing formulae completed! ✔"
  fi

  # cask
  if [[ ${OSTYPE} == "darwin"* ]]; then
    local installed=`brew cask list`
    local -a desired_formulae=(
      'google-chrome'
      'google-japanese-ime'
      'docker'
      'vagrant'
      'virtualbox'
      'xquartz'
    )
    local -a missing_formulae=()

    for index in "${!desired_formulae[@]}"
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
      echo "Installing missing Homebrew formulae..."
      brew cask install $list_formulae
      [[ $? ]] && scc "Install missing formulae completed! ✔"
    fi
  fi

  #ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
  #ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

  # Ricty
  if [ -z "${installed_ricty}"  ]; then
    echo "Reload fonts. This could take a while..."
    local cellar=/usr/local/Cellar
    find ${cellar}/ricty/*/share/fonts/Ricty*.ttf | xargs -I % cp % ~/Library/Fonts
    fc-cache -vf
  fi

  echo "Cleanup Homebrew..."
  brew cleanup
  brew cask cleanup
  scc "Cleanup Homebrew completed! ✔"
}
