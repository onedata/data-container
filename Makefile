ifndef SOURCE_DATA_DIR
$(error SOURCE_DATA_DIR is not set. Example, make push SOURCE_DATA_DIR=data)
endif
# Defined here only, to make shell completions suggest argument variables
SOURCE_DATA_DIR?=none

ifndef DATA_ARCHIVE
$(error DATA_ARCHIVE is not set. Example, make push DATA_ARCHIVE=data.zip)
endif
DATA_ARCHIVE?=none

ifndef DESCRIPTION
$(error DESCRIPTION is not set. Example, make push DESCRIPTION="800k of json files with foo")
endif
DESCRIPTION?=none

# Infer image name from git config
DATA_NAME ?= $(shell basename $(SOURCE_DATA_DIR))
PREFIX = $(shell git config --get remote.origin.url | tr ':.' '/'  | rev | cut -d '/' -f 3 | rev)
REPO_NAME = $(shell git config --get remote.origin.url | tr ':.' '/'  | rev | cut -d '/' -f 2 | rev)

# Linux and macos compatibility
MD5_COMMAND = $(shell type -p md5sum || type -p md5)
SOURCE_DATA_DIR_HASH = $(shell (md5 -q $(DATA_ARCHIVE) 2>/dev/null || md5sum $(DATA_ARCHIVE)  2>/dev/null)| cut -d' ' -f1)
$(info MD5 of the data archive SOURCE_DATA_DIR_HASH=$(SOURCE_DATA_DIR_HASH))
BUILD_DATE = $(shell date +'%y.%m.%d' | $(MD5_COMMAND) )

# Collect metadata
NUMBER_OF_FILES=$(shell find $(SOURCE_DATA_DIR) -type f | wc -l | cut -d' ' -f1)
NUMBER_OF_DIRECTORIES=$(shell find $(SOURCE_DATA_DIR) -mindepth 1 -type d | wc -l | cut -d' ' -f1)

# Construct docker image names
DATA_LATEST = $(PREFIX)/$(REPO_NAME):$(DATA_NAME)-latest
DATA_TAGED = $(PREFIX)/$(REPO_NAME):$(DATA_NAME)-$(SOURCE_DATA_DIR_HASH)

all: image push

image:
	echo "*" > .dockerignore
	echo "!$(SOURCE_DATA_DIR)" >> .dockerignore
	docker build --squash --build-arg NUMBER_OF_DIRECTORIES="$(NUMBER_OF_DIRECTORIES)" --build-arg NUMBER_OF_FILES="$(NUMBER_OF_FILES)" --build-arg SOURCE_DATA_DIR="$(SOURCE_DATA_DIR)" --build-arg DESCRIPTION="$(DESCRIPTION)"  -t $(DATA_LATEST) . # Build new image and automatically tag it as latest
	docker tag $(DATA_LATEST) $(DATA_TAGED)  # Add the version tag to the latest image

push:
	docker push $(DATA_LATEST) # Push image tagged as latest to repository
	docker push $(DATA_TAGED) # Push version tagged image to repository (since this image is already pushed it will simply create or update version tag)

clean:
	rm .dockerignore

.PHONY: all clean image push
