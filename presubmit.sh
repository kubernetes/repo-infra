#!/usr/bin/env bash
# Copyright 2019 The Kubernetes Authors.
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

set -o nounset
set -o errexit
set -o pipefail
set -o xtrace

cd "$(git rev-parse --show-toplevel)"
export GOPATH=${GOPATH:-$HOME/go}
mkdir -p "$GOPATH"
bazel build //:go
bazel build //:gofmt
export PATH=$PATH:$GOPATH/bin:$PWD/bazel-bin
export GOPATH=$GOPATH:/go  # TODO(fejta): fix this prow hack

GO111MODULE=on go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.18.0
export GO111MODULE=off
go get -u github.com/bazelbuild/buildtools/buildifier
# Build first since we need the generated protobuf for the govet checks
bazel build --config=ci //...
./verify/verify-boilerplate.sh --rootdir="$(pwd)" -v
GOPATH="${GOPATH}:$(pwd)/bazel-bin/verify/verify-go-src-go_path" ./verify/verify-go-src.sh --rootdir "$(pwd)" -v
./verify/verify-bazel.sh
buildifier -mode=check $(find . -name BUILD -o -name '*.bzl' -type f -not -wholename '*/vendor/*')
bazel test --config=ci //...
