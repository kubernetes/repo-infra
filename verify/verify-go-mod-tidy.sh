#!/usr/bin/env bash

# Copyright 2021 The Kubernetes Authors.
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

# This script verifies for a `go mod tidy` diff
# by looking at generated changes for go.mod and go.sum files

set -o errexit
set -o nounset
set -o pipefail

repo_root=$(dirname "${BASH_SOURCE}"})/..

go mod tidy

if ! _out="$(git --no-pager diff --exit-code --name-only go.mod go.sum)"; then
    echo "Generated output differs" >&2
    echo "${_out}" >&2
    echo "Verification for go-mod-tidy failed."
    exit 1
fi

echo "go mod tidy verified."
