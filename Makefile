IMAGE=ckhrulev/icebin-env:0.0.1

run: build
	docker run \
		--rm \
		-it \
		-v ${PWD}/../icebin:/home/builder/icebin \
		${IMAGE} \
		bash

build:
	docker build -t ${IMAGE} . | tee docker.log
