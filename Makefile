#
# File: https://github.com/cpp-projects-showcase/docker-images/blob/main/Makefile
# 

# Docker Hub organization
DCK_ORG := infrahelpers
DCK_PRJ := cpppython
DCK_REPO := $(DCK_ORG)/$(DCK_PRJ)

# Today's date
TODAY_DATE := $(shell date '+%Y%m%d')
EXTRACT_DATE := $(TODAY_DATE)

# Python - https://www.python.org/downloads/source/
PY312_VERSION := 3.12.13
PY313_VERSION := 3.13.13
PY314_VERSION := 3.14.4

# OS types
BASE_OS_PATHS := $(wildcard os/*)
BASE_OSES := $(patsubst os/%,%,$(BASE_OS_PATHS))
BUILD_IMGS := $(patsubst %,build-img-%,$(BASE_OSES))
PULL_IMGS := $(patsubst %,pull-img-%,$(BASE_OSES))
RUN_IMGS := $(patsubst %,run-img-%,$(BASE_OSES))
PUSH_IMGS := $(patsubst %,push-img-%,$(BASE_OSES))
BUILD_PUSH_IMGS := $(patsubst %,build-push-img-%,$(BASE_OSES))

.PHONY: help $(BUILD_IMGS) $(PULL_IMGS) $(RUN_IMGS) $(PUSH_IMGS) $(BUILD_PUSH_IMGS)

help: ## Display the help menu.
	@grep -h "\#\#" $(MAKEFILE_LIST)


$(BUILD_IMGS): build-img-%: ## Build the container image
	@base_os="$*" && \
	docker build -t $(DCK_REPO):$${base_os} \
		--build-arg PY312_VERSION="$(PY312_VERSION)" \
		--build-arg PY313_VERSION="$(PY313_VERSION)" \
		--build-arg PY314_VERSION="$(PY314_VERSION)" \
		os/$${base_os}/

$(PULL_IMGS): pull-img-%: ## Pull the container image
	@base_os="$*" && \
	docker pull $(DCK_REPO):$${base_os}

$(RUN_IMGS): run-img-%: ## Run the container image
	@base_os="$*" && \
	docker run --rm -it $(DCK_REPO):$${base_os} bash

$(PUSH_IMGS): push-img-%: ## Publish the container image
	@base_os="$*" && \
	docker push $(DCK_REPO):$${base_os}

$(BUILD_PUSH_IMGS): build-push-img-%: build-img-% push-img-% ## Build and push the container image

