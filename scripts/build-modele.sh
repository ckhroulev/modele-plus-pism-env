#!/bin/bash

set -x
set -e
set -u

echo "Using ModelE in ${MODELE_DIR} and data in ${MODELE_STAGING_DIR}..."

MODELE_BUILD=~/local/modele
MODELE_SUPPORT=~/modele-support

rm -rf ${MODELE_BUILD}
mkdir -p ${MODELE_BUILD}
# make a copy of ModelE sources to simulate "out of source" building
cp -r ${MODELE_DIR}/* ${MODELE_BUILD}

cd ${MODELE_BUILD}/decks

# remove and re-create the "support" directory
rm -rf ${MODELE_SUPPORT}
make config ModelE_Support=${MODELE_SUPPORT} SHELL=/bin/bash OVERWRITE=YES

# set compiler and MPI parameters
echo "COMPILER=gfortran" >> ~/.modelErc
echo "MPIDISTR=openmpi" >> ~/.modelErc
echo "MPIDIR=$HOME/local/spack" >> ~/.modelErc

RUNNAME=r01

cp ${MODELE_STAGING_DIR}/rundeck.R ./${RUNNAME}.R

make -j setup \
  RUN=${RUNNAME}  \
  MPI=YES \
  COMPILE_WITH_TRAPS=NO \
  NETCDFHOME=$HOME/local/spack \
  EXTRA_FFLAGS="-O0 -ggdb3 -fwrapv -fallow-argument-mismatch -fallow-invalid-boz" \
  EXTRA_LFLAGS="-O0 -ggdb3"  \
  2>&1 | tee ${MODELE_BUILD}/${RUNNAME}.compile.out
