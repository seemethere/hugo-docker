VERSIONS?=$(shell cat supported_versions)
LATEST?=$(shell head -n 1 supported_versions)
IMAGE_NAME=seemethere/hugo-docker

all: clean build push

.PHONY: clean
clean:
	-for version in $(VERSIONS); do \
		docker rmi -f "$(IMAGE_NAME):$$version"; \
	done

.PHONY: build
build:
	for version in $(VERSIONS); do \
		docker build --build-arg HUGO_VERSION=$$version -t "$(IMAGE_NAME):$$version" .; \
	done
	docker build --build-arg HUGO_VERSION=$(LATEST) -t "$(IMAGE_NAME):latest" .

.PHONY: push
push: build
	for version in $(VERSIONS); do \
		docker push "$(IMAGE_NAME):$$version"; \
	done
	docker push "$(IMAGE_NAME):latest"

supported_versions:
	docker run --rm -t -v "$(CURDIR)":/v -w /v buildpack-deps:scm sh -c 'bash get_hugo_versions | tee supported_versions'
