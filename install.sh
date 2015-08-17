#!/bin/sh

CURRENT_DIR=`pwd`
BIN_DIR=${CURRENT_DIR}/bin
INSTALL_DIR=~/.xcode_scripts

make_dir() {
  DIRPATH=$1
  if [ ! -d $DIRPATH ]; then
    mkdir -p $DIRPATH
    if [ $? -ne 0 ]; then
      echo "cannot make a directory."
      exit 1
    fi
  fi
}

make_dir $INSTALL_DIR
make_dir $INSTALL_DIR/bin
make_dir $INSTALL_DIR/lib

cd $INSTALL_DIR

for f in xcode_script.bash; do
  cp ${CURRENT_DIR}/${f} ${INSTALL_DIR}/
done

for f in xcopen xclist; do
  cp ${CURRENT_DIR}/bin/${f} ${INSTALL_DIR}/bin/
done

for f in xc_script.rb xccd.rb; do
  cp ${CURRENT_DIR}/lib/${f} ${INSTALL_DIR}/lib/
done

echo "Completed!"
echo "Please manually add follow line to .bash_profile"
echo "  source ${INSTALL_DIR}/xcode_script.bash"
