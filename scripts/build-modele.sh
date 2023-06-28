#!/bin/bash

set -x
set -e
set -u

RUNNAME=r01
MODELE_TMP=~/modele-tmp
MODELE_SUPPORT=~/modele-support

rm -rf ${MODELE_TMP}
cp -r ~/modele/ ${MODELE_TMP}
cd ${MODELE_TMP}/decks

rm -rf ${MODELE_SUPPORT}

make config ModelE_Support=${MODELE_SUPPORT} SHELL=/bin/bash OVERWRITE=YES

echo "COMPILER=gfortran" >> ~/.modelErc
echo "MPIDISTR=openmpi" >> ~/.modelErc
echo "MPIDIR=$HOME/local/spack" >> ~/.modelErc

make rundeck RUN=${RUNNAME} RUNSRC=E4F40

make -j setup \
  RUN=${RUNNAME}  \
  MPI=YES \
  COMPILE_WITH_TRAPS=NO \
  NETCDFHOME=$HOME/local/spack \
  EXTRA_FFLAGS="-O0 -ggdb3 -fwrapv -fallow-argument-mismatch -fallow-invalid-boz" \
  EXTRA_LFLAGS="-O0 -ggdb3"  \
  2>&1 | tee ${MODELE_TMP}/${RUNNAME}.compile.out
