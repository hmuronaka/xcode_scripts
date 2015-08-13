#!/bin/sh

PROJECT_PATH=`xccd.rb $1 | sed -n '$p'`
pushd ${PROJECT_PATH}
