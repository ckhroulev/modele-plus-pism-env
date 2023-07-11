#!/bin/bash

set -e
set -x
set -u

BUILD_DIR=~/local/build/icebin
PREFIX=$HOME/local/icebin

mkdir -p ${BUILD_DIR}
rm -f ${BUILD_DIR}/CMakeCache.txt

# ibmisc headers are full of these...
IGNORED_WARNINGS="-Wno-ignored-attributes -Wno-narrowing -Wno-vexing-parse -Wno-return-type -Wno-deprecated-declarations -Wno-format"

# prefixes to use when looking for dependencies (have to be absolute paths; don't use ~)
PREFIXES="$HOME/local/blitz;$HOME/local/ibmisc;$HOME/local/spack;$HOME/local/pism"

cmake -S ${ICEBIN_DIR} -B ${BUILD_DIR} \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_CXX_FLAGS="${IGNORED_WARNINGS}" \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCGAL_DO_NOT_WARN_ABOUT_CMAKE_BUILD_TYPE=TRUE \
      -DCMAKE_PREFIX_PATH=${PREFIXES} \
      -DUSE_PISM=TRUE \
      -DBUILD_MODELE=TRUE \
      -Wno-dev \
  2>&1 | tee ${BUILD_DIR}/configure.log

make -j 8 -C ${BUILD_DIR} install
