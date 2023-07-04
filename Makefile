IMAGE=ckhrulev/icebin-env:0.0.1

IBMISC_DIR ?= ${PWD}/../ibmisc
ICEBIN_DIR ?= ${PWD}/../icebin
PISM_DIR ?= ${PWD}/../pism
MODELE_DIR ?= ${PWD}/../modelE

MODELE_STAGING_DIR ?= ${PWD}/modele_staging
SCRIPTS_DIR = ${PWD}/scripts

run: build
	docker run \
		--rm \
		-it \
		-v ${ICEBIN_DIR}:/opt/icebin -e ICEBIN_DIR=/opt/icebin \
		-v ${IBMISC_DIR}:/opt/ibmisc -e IBMISC_DIR=/opt/ibmisc \
		-v ${PISM_DIR}:/opt/pism -e PISM_DIR=/opt/pism \
		-v ${MODELE_DIR}:/opt/modele -e MODELE_DIR=/opt/modele \
		-v ${MODELE_STAGING_DIR}:/opt/modele_staging -e MODELE_STAGING_DIR=/opt/modele_staging \
		-v ${SCRIPTS_DIR}:/opt/scripts -e SCRIPTS_DIR=/opt/scripts \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} .

stage:
	${MAKE} -C modele_staging clean container
