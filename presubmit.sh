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

# TODO(fejta): remove this if block, just run else after moving off travis
if [[ -n "${TRAVIS_BUILD_DIR:-}" ]]; then
  LATEST_GO=$(gimme --known | sort -V | tail -1)
  eval "$(gimme ${LATEST_GO})"
  mkdir -p $GOPATH/src/k8s.io
  mv $TRAVIS_BUILD_DIR $GOPATH/src/k8s.io
  cd $GOPATH/src/k8s.io/repo-infra
  echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
  curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install bazel
else
  echo "We do not appear to be in travis CI..." >&2
  cd "$(git rev-parse --show-toplevel)"
  export GOPATH=${GOPATH:-$HOME/go}
  mkdir -p "$GOPATH"
  bazel build //:go
  bazel build //:gofmt
  bazel build //:golangci-lint
  bazel build //:buildifier
  export PATH=$PATH:$GOPATH/bin:$PWD/bazel-bin
  export GOPATH=$GOPATH:/go  # prow hack
fi

export GO111MODULE=off
# Build first since we need the generated protobuf for the govet checks
bazel build --config=ci //...
./verify/verify-boilerplate.sh --rootdir="$(pwd)" -v
GOPATH="${GOPATH}:$(pwd)/bazel-bin/verify/verify-go-src-go_path" ./verify/verify-go-src.sh --rootdir "$(pwd)" -v
./verify/verify-bazel.sh
buildifier -mode=check $(find . -name BUILD -o -name '*.bzl' -type f -not -wholename '*/vendor/*')
bazel test --config=ci //...
