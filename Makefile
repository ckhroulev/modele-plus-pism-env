IMAGE=ckhrulev/icebin-env:0.0.1

build:
	docker build -t ${IMAGE} .

run:
	docker run \
		--rm \
		-it \
		-v ${PWD}/../icebin:/home/builder/icebin \
		${IMAGE} \
		bash
