#!/usr/bin/env bash
# Copyright 2017 The Kubernetes Authors.
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

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") [module]" >&2
  echo >&2
  echo "  module: import name of this module, like k8s.io/repo-infra" >&2
  exit 1
fi

log() {
  (
    set -o xtrace
    "$@"
  )
}


if [[ ! -e go.mod ]]; then
  echo "Creating $1..." >&2
  log bazel run //:go -- mod init "$1"
fi

module=$(head -n 1 go.mod | cut -d ' ' -f 2-)
if [[ "$module" != "$1" ]]; then
  echo "Wrong module: $module != expected $1" >&2
  exit 1
fi
echo "Updating $module..."
log hack/update-deps.sh
