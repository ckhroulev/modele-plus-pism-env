IMAGE=ckhrulev/icebin-env:0.0.1

ICEBIN ?= ${PWD}/../icebin
PISM ?= ${PWD}/../pism
MODELE ?= ${PWD}/../modelE

SCRIPTS = ${PWD}/scripts

run: build
	docker run \
		--rm \
		-it \
		-v ${ICEBIN}:/opt/icebin -e ICEBIN_DIR=/opt/icebin \
		-v ${PISM}:/opt/pism -e PISM_DIR=/opt/pism \
		-v ${MODELE}:/opt/modele -e MODELE_DIR=/opt/modele \
		-v ${SCRIPTS}:/opt/scripts -e SCRIPTS_DIR=/opt/scripts \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} .
