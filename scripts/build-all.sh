#!/bin/bash

set -e
set -x
set -u

pushd $SCRIPTS_DIR
./build-pism.sh
./build-ibmisc.sh
./build-icebin.sh
./build-modele.sh
popd
