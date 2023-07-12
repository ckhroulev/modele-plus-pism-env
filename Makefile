IMAGE=ckhrulev/icebin-env:0.0.1

IBMISC_DIR ?= ${PWD}/../ibmisc
ICEBIN_DIR ?= ${PWD}/../icebin
PISM_DIR ?= ${PWD}/../pism
MODELE_DIR ?= ${PWD}/../modelE

MODELE_DATA_DIR ?= ${PWD}/modele_staging
SCRIPTS_DIR ?= ${PWD}

run: build build-pism.sh build-ibmisc.sh build-icebin.sh build-modele.sh run-modele.sh
	docker run \
		--rm \
		-it \
		-v ${ICEBIN_DIR}:/opt/icebin -e ICEBIN_DIR=/opt/icebin \
		-v ${IBMISC_DIR}:/opt/ibmisc -e IBMISC_DIR=/opt/ibmisc \
		-v ${PISM_DIR}:/opt/pism     -e PISM_DIR=/opt/pism \
		-v ${MODELE_DIR}:/opt/modele -e MODELE_DIR=/opt/modele \
		-v ${MODELE_DATA_DIR}:/opt/modele_data -e MODELE_DATA_DIR=/opt/modele_data \
		-v ${SCRIPTS_DIR}:/opt/scripts -e SCRIPTS_DIR=/opt/scripts \
		${IMAGE} \
		bash

build: Dockerfile
	docker build -t ${IMAGE} .

stage:
	${MAKE} -C modele_staging clean container

Dockerfile build-pism.sh build-ibmisc.sh build-icebin.sh build-modele.sh run-modele.sh: docker.org
	emacs -Q --batch -l org $^ -f org-babel-tangle
