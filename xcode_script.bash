#!/bin/sh

WORK_DIR=~/.xcode_scripts
LIB_DIR=${WORK_DIR}/lib
export PATH=$PATH:~/.xcode_scripts/bin

alias xo='xcopen'
alias xc='xccd'

xccd() {
  # sed -n $p: print last line.
  PROJECT_PATH=`${LIB_DIR}/xccd.rb $1 | sed -n '$p'`

  # PROJECT_PATH.length > 0 
  if [ -n "${PROJECT_PATH}" ]; then
    pushd ${PROJECT_PATH}
  fi
}

_xccd() {
  CURRENT_DIR=`xcconfig search_path`
  PROJECT_NAMES=`xclist ${CURRENT_DIR}`
  COMPREPLY=( `compgen -W "${PROJECT_NAMES}" $2`) 
}

_xcopen() {
  CURRENT_DIR=`xcconfig search_path`
  PROJECT_NAMES=`xclist ${CURRENT_DIR}`
  COMPREPLY=( `compgen -W "${PROJECT_NAMES}" $2`) 
}


complete -F _xccd xccd
complete -F _xccd xc
complete -F _xcopen xcopen
complete -F _xcopen xo

