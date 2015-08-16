#!/bin/sh

xccd() {
  PROJECT_PATH=`xccd.rb $1 | sed -n '$p'`
  pushd ${PROJECT_PATH}
}

_xccd() {
  CURRENT_DIR=`pwd`
  PROJECT_NAMES=`xclist ${CURRENT_DIR}`
  COMPREPLY=( `compgen -W "${PROJECT_NAMES}" $2`) 
}

complete -F _xccd xccd
