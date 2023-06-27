#!/bin/bash

PISM_DIR=$HOME/pism
PREFIX=$HOME/local/pism
BUILD_DIR=/tmp/pism-build

git clone -b mankoff/pism-upgrade https://github.com/NASA-GISS/pism.git ${PISM_DIR} || true

mkdir -p ${BUILD_DIR}
rm -f ${BUILD_DIR}/CMakeCache.txt

export CC=mpicc
export CXX=mpicxx

cmake -S ${PISM_DIR} -B ${BUILD_DIR} \\
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \\
  -DPism_USE_EVERYTRACE=TRUE \\
  ;

make -C ${BUILD_DIR} install
