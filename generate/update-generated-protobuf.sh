#!/bin/bash

# Copyright 2015 The Kubernetes Authors.
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

source "$(dirname ${BASH_SOURCE})/lib/init.sh"

repo::golang::setup_env

BOILERPLATE_FILE="${REPO_INFRA_ROOT}/verify/boilerplate/boilerplate.go.txt"

BINS=(
	vendor/k8s.io/repo-infra/generate/cmd/libs/go2idl/go-to-protobuf
	vendor/k8s.io/repo-infra/generate/cmd/libs/go2idl/go-to-protobuf/protoc-gen-gogo
)

repo::golang::build_binaries "${BINS[@]}"
repo::golang::place_bins

if [[ -z "$(which protoc)" || "$(protoc --version)" != "libprotoc 3."* ]]; then
  echo "Generating protobuf requires protoc 3.0.0-beta1 or newer. Please download and"
  echo "install the platform appropriate Protobuf package for your OS: "
  echo
  echo "  https://github.com/google/protobuf/releases"
  echo
  echo "WARNING: Protobuf changes are not being validated"
  exit 1
fi

gotoprotobuf=$(repo::util::find-binary "go-to-protobuf")

TARGET_GVS=(${REPO_AVAILABLE_GROUP_VERSIONS})

TARGET_PACKAGES=(
	"+k8s.io/apimachinery/pkg/util/intstr"
	"+k8s.io/apimachinery/pkg/api/resource"
	"+k8s.io/apimachinery/pkg/runtime/schema"
	"+k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/apis/meta/v1"
	${REPO_EXTRA_PROTO_IMPORTS}
)
for gv in "${TARGET_GVS[@]}"; do
    api_dir=$(repo::util::group-version-to-pkg-path "${gv}")
    pkg="${REPO_GO_PACKAGE}/${api_dir}"
    TARGET_PACKAGES+=("${pkg}")
done
TARGET_PACKAGES_CSV=$(IFS=',';echo "${TARGET_PACKAGES[*]// /,}";IFS=$)


# requires the 'proto' tag to build (will remove when ready)
# searches for the protoc-gen-gogo extension in the output directory
# satisfies import of github.com/gogo/protobuf/gogoproto/gogo.proto and the
# core Google protobuf types
PATH="${REPO_ROOT}/_output/bin:${PATH}" \
  "${gotoprotobuf}" \
  --proto-import="${REPO_ROOT}/vendor" \
  --proto-import="${REPO_ROOT}/vendor/k8s.io/repo-infra/generate/third_party/protobuf" \
  --vendor-output-base="${REPO_ROOT}/vendor" \
  --go-header-file="${BOILERPLATE_FILE}" \
  --packages="${TARGET_PACKAGES_CSV}" \
  "$@"

