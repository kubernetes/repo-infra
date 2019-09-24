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

cd "$(git rev-parse --show-toplevel)"
export GOPATH=${GOPATH:-$HOME/go}
mkdir -p "$GOPATH"
if [[ -n "${GOOGLE_APPLICATION_CREDENTIALS:-}" ]]; then
  echo "Service account detected. Adding --config=ci to bazel commands" >&2
  mkdir -p "$HOME"
  touch "$HOME/.bazelrc"
  echo "build --config=ci" >> "$HOME/.bazelrc"
fi
tools=(
  //:go
  //:gofmt
  //:golangci-lint
  //:buildifier
)
(
  # Download all tool outputs until we migrate to using bazel run
  set -o xtrace
  bazel build --experimental_remote_download_outputs=all "${tools[@]}"
)
export PATH=$PATH:$GOPATH/bin:$PWD/bazel-bin
export GOPATH=$GOPATH:/go  # TODO(fejta): fix this prow hack
export GO111MODULE=off # TODO(fejta): get rid of this
# Build first since we need the generated protobuf for the govet checks
(
  set -o xtrace
  bazel test //... # This also builds everything
  ./verify/verify-boilerplate.sh --rootdir="$(pwd)" -v
  GOPATH="${GOPATH}:$(pwd)/bazel-bin/verify/verify-go-src-go_path" ./verify/verify-go-src.sh --rootdir "$(pwd)" -v
  ./verify/verify-bazel.sh
  buildifier -mode=check $(find . -name BUILD -o -name '*.bzl' -type f -not -wholename '*/vendor/*')
)
