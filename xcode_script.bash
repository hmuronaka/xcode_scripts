#!/bin/sh

WORK_DIR=~/.xcode_scripts
LIB_DIR=${WORK_DIR}/lib
export PATH=$PATH:~/.xcode_scripts/bin

xccd() {
  PROJECT_PATH=`${LIB_DIR}/xccd.rb $1 | sed -n '$p'`
  pushd ${PROJECT_PATH}
}

_xccd() {
  CURRENT_DIR=`pwd`
  PROJECT_NAMES=`xclist ${CURRENT_DIR}`
  COMPREPLY=( `compgen -W "${PROJECT_NAMES}" $2`) 
}

_xcopen() {
  CURRENT_DIR=`pwd`
  PROJECT_NAMES=`xclist ${CURRENT_DIR}`
  COMPREPLY=( `compgen -W "${PROJECT_NAMES}" $2`) 
}


complete -F _xccd xccd
complete -F _xcopen xcopen
