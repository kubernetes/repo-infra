#!/usr/bin/env bash
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

set -o errexit
set -o nounset
set -o pipefail

cd $(git rev-parse --show-toplevel)

rm -rf vendor
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org
export GOSUMDB=sum.golang.org
bazel run //:go -- mod tidy
bazel run //:gazelle -- fix -mode=fix
bazel run //:gazelle -- update-repos \
  --from_file=go.mod --to_macro=repos.bzl%go_repositories \
  --build_file_generation=on --build_file_proto_mode=disable
bazel run //:kazel
