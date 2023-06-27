IMAGE=ckhrulev/icebin-env:0.0.1
ICEBIN=${PWD}/../icebin
PISM=${PWD}/../pism
SCRIPTS=${PWD}/scripts

run: build
	docker run \
		--rm \
		-it \
		-v ${ICEBIN}:/home/builder/icebin \
		-v ${PISM}:/home/builder/pism \
		-v ${SCRIPTS}:/home/builder/scripts \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} .
