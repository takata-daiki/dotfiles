#!/bin/bash
set -e
OS="$(uname -s)"
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/takata-daiki/dotfiles/tarball/master"
REMOTE_URL="git@github.com:takata-daiki/dotfiles.git"

ESC="\033["
ESCEND=m
ESCOFF="\033[0m"

SUCCESS="${ESC}32${ESCEND}Success${ESCOFF}"
INFO="${ESC}36${ESCEND}Info...${ESCOFF}"
SKIP="${ESC}34${ESCEND}Skip...${ESCOFF}"
WARNING="${ESC}33${ESCEND}Warning${ESCOFF}"
FAILED="${ESC}31${ESCEND}FAILED!${ESCOFF}"

function msg() {
  local MESSAGE=$(echo "$@" | sed -e "s/\\\n/\n                              /g")
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${MESSAGE}" >&1
}

function err() {
  local MESSAGE=$(echo "$@" | sed -e "s/\\\n/\n                              /g")
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${FAILED} $*" >&2
}

has() {
  type "$1" > /dev/null 2>&1
}

usage() {
  name=`basename $0`
  cat <<EOF

Usage:  $name [OPTIONS] COMMAND

Options:
  -f  Overwrite dotfiles
  -h  Print help (this message)

Commands:
  deploy  Create symlink to home directory
  init    Setup environment settings

To complete this dotfiles, run './$name init' then './$name deploy'.
EOF
  exit 1
}

while getopts :f:h opt; do
  case ${opt} in
    f)
      OVERWRITE=true
      ;;
    h)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# If missing, download and extract the dotfiles repository
if [ ! -d ${DOT_DIRECTORY} ]; then
  msg "${INFO} Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}

  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

  msg "${SUCCESS} Dotfiles are downloaded!"
fi

cd ${DOT_DIRECTORY}
source ./lib/brew.sh
source ./lib/yadr.sh
source ./lib/dein.sh
source ./lib/powerline.sh

deploy() {
  msg "${INFO} Deploying dotfiles..."
  for f in .??*
  do
    # Force remove the vim directory if it's already there
    [ -n "${OVERWRITE}" -a -e ${HOME}/${f} ] && rm -f ${HOME}/${f}
    if [ ! -e ${HOME}/${f} ]; then
      # If you have ignore files, add file/directory name here
      [[ ${f} == ".git" ]] && continue
      [[ ${f} == ".gitignore" ]] && continue
      ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    fi
  done

  msg "${SUCCESS} Dotfiles are deployed!"
}

init() {
  msg "${INFO} Initializing dotfiles..."
  if has "brew"; then
    msg "${SKIP} Install Homebrew"
    run_brew
  else
    BREW_INSTALL_MSG="${WARNING} This environment is not installed 'brew'"
    case ${OSTYPE} in
      darwin*)
        msg "${INFO} Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        run_brew
        ;;
      linux*)
        msg "${BREW_INSTALL_MSG}\nGet Here! ==> ${ESC}4${ESCEND}http://linuxbrew.sh/${ESCOFF}"
        return 0
        ;;
      *)
        msg "${FAILED} This dotfiles do not support ${OSTYPE}"
        return 0;
        ;;
    esac
  fi

  run_yadr
  run_dein
  run_powerline

  [ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh

  #if [ ! -d ${HOME}/.anyenv ]; then
  #  git clone https://github.com/riywo/anyenv ~/.anyenv
  #  anyenv install goenv
  #  anyenv install rbenv
  #  anyenv install pyenv
  #  anyenv install phpenv
  #  anyenv install ndenv
  #  exec $SHELL -l
  #fi

  [ ! -d ${HOME}/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

  set +e
  #if has "pyenv"; then
  #  [ ! -d $(pyenv root)/plugins/pyenv-virtualenv ] && git clone https://github.com/yyuu/pyenv-virtualenv $(pyenv root)/plugins/pyenv-virtualenv
  #  # pyenv virtualenv -f ${latest} neovim3
  #  # pyenv activate neovim3
  #  # pip install neovim
  #fi
  #if has "rbenv"; then
  #  [ ! -d $(rbenv root)/plugins/rbenv-default-gems ] && git clone -q https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
  #  [ ! -e $(rbenv root)/default-gems ] && cp ${DOT_DIRECTORY}/default-gems $(rbenv root)/default-gems
  #fi
  #if [ ! -d $HOME/.cargo ]; then
  #  curl https://sh.rustup.rs -sSf | sh -s -- -y
  #fi

  msg "${SUCESS} Dotfiles Initialized!"
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  deploy)
    deploy
    ;;
  init)
    init
    ;;
  *)
    usage
    ;;
esac

exit 0
