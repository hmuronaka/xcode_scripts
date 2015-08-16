#!/bin/sh

CURRENT_DIR=`pwd`
BIN_DIR=${CURRENT_DIR}/bin

usage() {
  echo "install.sh <install-dir-path>"
  echo ""
  echo "Option:"
  echo "\tinstall-dir-path: input a path, like ~/bin/." 
}

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

INSTALL_DIR=$1

if [ ! -d $INSTALL_DIR ]; then
  mkdir -p $INSTALL_DIR
  if [ $? -ne 0 ]; then
    echo "cannot make a directory."
    exit 1
  fi
fi

cd $INSTALL_DIR

for f in xcopen xclist xccd.rb; do
  ln -s ${BIN_DIR}/${f} ${f}
done

echo "Completed!"
echo "Please add ${INSTALL_DIR} to PATH environment variable!"
