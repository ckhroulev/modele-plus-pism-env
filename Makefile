IMAGE=ckhrulev/icebin-env:0.0.1

IBMISC_DIR ?= ${PWD}/../ibmisc
ICEBIN_DIR ?= ${PWD}/../icebin
PISM_DIR ?= ${PWD}/../pism
MODELE_DIR ?= ${PWD}/../modelE

MODELE_DATA_DIR ?= ${PWD}/modele_data
TOOLS_DIR ?= ${PWD}

SCRIPTS=build-all.sh build-pism.sh build-ibmisc.sh build-icebin.sh build-modele.sh run-modele.sh
GENERATED=${SCRIPTS} icebin.cdl.template rundeck.R Dockerfile

run: build ${SCRIPTS}
	docker run \
		--rm \
		-it \
		-v ${ICEBIN_DIR}:/opt/icebin -e ICEBIN_DIR=/opt/icebin \
		-v ${IBMISC_DIR}:/opt/ibmisc -e IBMISC_DIR=/opt/ibmisc \
		-v ${PISM_DIR}:/opt/pism     -e PISM_DIR=/opt/pism \
		-v ${MODELE_DIR}:/opt/modele -e MODELE_DIR=/opt/modele \
		-v ${MODELE_DATA_DIR}:/opt/modele_data -e MODELE_DATA_DIR=/opt/modele_data \
		-v ${TOOLS_DIR}:/opt/tools   -e TOOLS_DIR=/opt/tools \
		${IMAGE} \
		bash

build: Dockerfile
	docker build -t ${IMAGE} .

stage:
	${MAKE} -C modele_staging clean container

${GENERATED}: notes.org
	emacs -Q --batch -l org $^ -f org-babel-tangle
	chmod a+x ${SCRIPTS}

clean:
	@rm -f ${GENERATED}
