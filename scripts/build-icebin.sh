#!/bin/bash

ICEBIN_DIR=~/icebin
BUILD_DIR=~/icebin-build

mkdir -p ${BUILD_DIR}
rm -f ${BUILD_DIR}/CMakeCache.txt

# ibmisc headers are full of these...
IGNORED_WARNINGS="-Wno-ignored-attributes -Wno-narrowing -Wno-vexing-parse -Wno-return-type -Wno-deprecated-declarations -Wno-format"

cmake -S ${ICEBIN_DIR} -B ${BUILD_DIR} \
      -DCMAKE_CXX_FLAGS="${IGNORED_WARNINGS}" \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCGAL_DO_NOT_WARN_ABOUT_CMAKE_BUILD_TYPE=TRUE \
      -DCMAKE_FIND_ROOT_PATH="~/local/blitz;~/local/ibmisc;~/local/spack;~/local/pism" \
      -DUSE_PISM=TRUE \
  ;

make -C ${BUILD_DIR} install
