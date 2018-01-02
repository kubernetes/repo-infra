# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DBG_MAKEFILE ?=
ifeq ($(DBG_MAKEFILE),1)
    $(warning ***** starting Makefile for goal(s) "$(MAKECMDGOALS)")
    $(warning ***** $(shell date))
else
    # If we're not debugging the Makefile, don't echo recipes.
    MAKEFLAGS += -s
endif

ifeq ("$(wildcard repo-infra-config.sh)", "")
    $(error No repo-infra-config.sh file found.  You must run this from the root repository directory (e.g. `make -f vendor/k8s.io/repo-infra/Makefile`))
endif

# Old-skool build tools.
#
# Commonly used targets (see each target for more information):
#   all: Build code.
#   test: Run tests.
#   clean: Clean up.

# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /bin/bash

# We don't need make's built-in rules.
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

# Constants used throughout.
.EXPORT_ALL_VARIABLES:
OUT_DIR ?= _output
BIN_DIR := $(OUT_DIR)/bin
GENERATED_FILE_PREFIX := zz_generated.

# Metadata for driving the build lives here.
META_DIR := .make

# Our build flags.
# TODO(thockin): it would be nice to just use the native flags.  Can we EOL
#                these "wrapper" flags?
KUBE_GOFLAGS := $(GOFLAGS)
KUBE_GOLDFLAGS := $(GOLDFLAGS)
KUBE_GOGCFLAGS = $(GOGCFLAGS)

# This controls the verbosity of the build.  Higher numbers mean more output.
KUBE_VERBOSE ?= 1


define GENERATED_FILES_HELP_INFO
# Produce auto-generated files needed for the build.
#
# Example:
#   make generated_files
endef
.PHONY: generated_files
ifeq ($(PRINT_HELP),y)
generated_files:
	@echo "$$GENERATED_FILES_HELP_INFO"
else
generated_files:
	$(MAKE) -f vendor/k8s.io/repo-infra/Makefile.generated_files $@ CALLED_FROM_MAIN_MAKEFILE=1
endif
