#!/bin/bash

set -e
set -x
set -u

BUILD_DIR=~/local/build/ibmisc
PREFIX=$HOME/local/ibmisc

mkdir -p ${BUILD_DIR}
rm -f ${BUILD_DIR}/CMakeCache.txt

cmake -S ${IBMISC_DIR} -B ${BUILD_DIR} \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_FIND_ROOT_PATH=~/local/blitz \
      -DCMAKE_CXX_FLAGS="-fpermissive -w" \
  ;

make -C ${BUILD_DIR} install
