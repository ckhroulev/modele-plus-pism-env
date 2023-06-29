IMAGE=ckhrulev/icebin-env:0.0.1

ICEBIN_DIR ?= ${PWD}/../icebin
PISM_DIR ?= ${PWD}/../pism
MODELE_DIR ?= ${PWD}/../modelE

SCRIPTS_DIR = ${PWD}/scripts

run: build
	docker run \
		--rm \
		-it \
		-v ${ICEBIN_DIR}:/opt/icebin -e ICEBIN_DIR=/opt/icebin \
		-v ${PISM_DIR}:/opt/pism -e PISM_DIR=/opt/pism \
		-v ${MODELE_DIR}:/opt/modele -e MODELE_DIR=/opt/modele \
		-v ${SCRIPTS_DIR}:/opt/scripts -e SCRIPTS_DIR=/opt/scripts \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} .
