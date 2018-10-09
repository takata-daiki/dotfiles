#!/bin/bash
set -e
OS="$(uname -s)"
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/takata-daiki/dotfiles/tarball/master"
REMOTE_URL="https://github.com/takata-daiki/dotfiles.git"

RED="$(tput setaf 1)"
GRN="$(tput setaf 2)"
YLW="$(tput setaf 3)"
RST="$(tput sgr0)"

err() {
  local MESSAGE=$(echo "$@" | sed -e "s/\\\n/\n                              /g")
  echo -e "${RED}${MESSAGE}${RST}" >&2
}

scc() {
  local MESSAGE=$(echo "$@" | sed -e "s/\\\n/\n                              /g")
  echo -e "${GRN}${MESSAGE}${RST}" >&1
}

wrn() {
  local MESSAGE=$(echo "$@" | sed -e "s/\\\n/\n                              /g")
  echo -e "${YLW}${MESSAGE}${RST}" >&1
}

has() {
  type "$1" > /dev/null 2>&1
}

usage() {
  name=`basename $0`
  cat << EOS

Usage:  $name [OPTIONS] COMMAND

Options:
  -f  Overwrite dotfiles
  -h  Print help (this message)

Commands:
  deploy  Create symlink to home directory
  init    Setup environment settings

To complete this dotfiles, run '~/dotfiles/install.sh init' -> '~/dotfiles/install.sh deploy'.
EOS
  exit 1
}

while getopts :f:h opt
do
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
  echo "Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}

  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

  scc "Download dotfiles completed! ✔"
fi

cd ${DOT_DIRECTORY}
source ./lib/brew.sh
source ./lib/apt-get.sh
source ./lib/tpm.sh
source ./lib/anyenv.sh
source ./lib/spacevim.sh
source ./lib/fisher.sh

deploy() {
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

  scc "Deploy dotfiles completed! ✔"
}

init() {
  case ${OSTYPE} in
    darwin*)
      run_brew
      echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
      ;;
    linux*)
      run_apt
      ;;
    *)
      err "Working only OSX / Ubuntu!!"
      exit 1;
      ;;
  esac

  run_tpm
  run_anyenv
  run_spacevim
  run_fisher

  echo 'tmux' >> ${HOME}/.bashrc
  echo 'exec fish' >> ${HOME}/.bashrc
  exec fish && fisher
  scc "Initialize dotfiles completed! ✔"
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  deploy)
    deploy
    ;;
  init*)
    init
    ;;
  *)
    usage
    ;;
esac

exit 0
