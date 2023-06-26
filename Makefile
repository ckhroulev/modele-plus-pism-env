IMAGE=ckhrulev/icebin-env:0.0.1
ICEBIN=${PWD}/../icebin

run: build
	docker run \
		--rm \
		-it \
		-v ${ICEBIN}:/home/builder/icebin \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} .
