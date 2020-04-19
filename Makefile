IMAGE_NAME := "marshians/arch-repo"

build:
	docker build -t $(IMAGE_NAME) .
.PHONY: build

push:
	docker push $(IMAGE_NAME)
.PHONY: push

run:
	docker run --rm -p 8080:8080 $(IMAGE_NAME)
.PHONY: run
