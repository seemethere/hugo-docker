VERSIONS?=$(shell cat supported_versions)
LATEST?=$(shell head -n 1 supported_versions)
IMAGE_NAME=seemethere/hugo-docker
IMG_RUN=docker run --rm -it \
	--name img-hugo-docker \
	--volume $(CURDIR):/home/user/src:ro \
	--workdir /home/user/src \
	--volume "$$HOME/.docker:/root/.docker:ro" \
	--cap-add SETGID \
	--cap-add SETUID \
	--security-opt apparmor=unconfined \
	--security-opt seccomp=unconfined \
	r.j3ss.co/img
BUILD=$(IMG_RUN) build

all: clean build push

.PHONY: clean
clean:
	-for version in $(VERSIONS); do \
		docker rmi -f "$(IMAGE_NAME):$$version"; \
	done

.PHONY: build
build:
	for version in $(VERSIONS); do \
		$(BUILD) -t "$(IMAGE_NAME):$$version" --build-arg HUGO_VERSION=$$version .; \
	done
	$(BUILD) -t "$(IMAGE_NAME):latest" --build-arg HUGO_VERSION=$(LATEST) .

.PHONY: push
push: build
	for version in $(VERSIONS); do \
		docker push "$(IMAGE_NAME):$$version"; \
	done
	docker push "$(IMAGE_NAME):latest"

supported_versions:
	docker run --rm -t -v "$(CURDIR)":/v -w /v buildpack-deps:scm sh -c 'bash get_hugo_versions | tee supported_versions'
