#!/bin/bash

set -e
set -u
set -x

# The variable PISM_DIR should point to PISM's source tree.

PREFIX=$HOME/local/pism
BUILD_DIR=$HOME/build/pism

mkdir -p ${BUILD_DIR}
rm -f ${BUILD_DIR}/CMakeCache.txt

export CC=mpicc
export CXX=mpicxx

cmake -S ${PISM_DIR} -B ${BUILD_DIR} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DPism_USE_EVERYTRACE=TRUE \
  -DPism_BUILD_ICEBIN=TRUE \
  -DCMAKE_BUILD_TYPE=Debug \
  ;

make -j8 -C ${BUILD_DIR} install
