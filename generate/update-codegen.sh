#!/bin/bash

# Copyright 2014 The Kubernetes Authors.
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

BUILD_TARGETS=(
  vendor/k8s.io/repo-infra/generate/cmd/libs/go2idl/client-gen
  vendor/k8s.io/repo-infra/generate/cmd/libs/go2idl/lister-gen
  vendor/k8s.io/repo-infra/generate/cmd/libs/go2idl/informer-gen
)

# build the requisite tools
repo::golang::build_binaries "${BUILD_TARGETS[@]}"
repo::golang::place_bins

clientgen=$(repo::util::find-binary "client-gen")
listergen=$(repo::util::find-binary "lister-gen")
informergen=$(repo::util::find-binary "informer-gen")

# Please do not add any logic to this shell script. Add logic to the go code
# that generates the set-gen program.
#

GROUP_VERSIONS=(${REPO_AVAILABLE_GROUP_VERSIONS})
GV_DIRS=()
typeset -A GUNV_DIRS_SET
for gv in "${GROUP_VERSIONS[@]}"; do
    # add items, but strip off any leading apis/ you find to match command expectations
    api_dir=$(repo::util::group-version-to-pkg-path "${gv}")
    nopkg_dir=${api_dir#pkg/}
    pkg_dir=${nopkg_dir#apis/}
    unver_pkg_dir=${pkg_dir%/*}

    # skip groups that aren't being served, clients for these don't matter
    if [[ " ${REPO_NO_CLIENT_GROUP_VERSIONS} " == *" ${gv} "* ]]; then
        continue
    fi

    GV_DIRS+=("${pkg_dir}")
    GUNV_DIRS_SET[${unver_pkg_dir}/]=1
done

if [[ ${#GV_DIRS[@]} -eq 0 ]]; then
    echo "No clients/informers/listers to generate, exiting."
    exit 0
fi

GUNV_DIRS=("${!GUNV_DIRS_SET[@]}")

# delimit by commas for the command
GV_DIRS_CSV=$(IFS=',';echo "${GV_DIRS[*]// /,}";IFS=$)
GUNV_DIRS_CSV=$(IFS=',';echo "${GUNV_DIRS[*]// /,}";IFS=$)

# This can be called with one flag, --verify-only, so it works for both the
# update- and verify- scripts.
${clientgen} --input="${GUNV_DIRS_CSV}" --input-base="${REPO_GO_PACKAGE}/pkg/apis" --clientset-path="${REPO_GO_PACKAGE}/pkg/client/clientset_generated" --go-header-file="${BOILERPLATE_FILE}" "$@"
${clientgen} --clientset-name="clientset" --input="${GV_DIRS_CSV}" --input-base="${REPO_GO_PACKAGE}/pkg/apis" --clientset-path="${REPO_GO_PACKAGE}/pkg/client/clientset_generated" --go-header-file="${BOILERPLATE_FILE}" "$@"

LISTERGEN_APIS=(
$(
  cd ${REPO_ROOT}
  find pkg/apis -name types.go | xargs -n1 dirname | sort
)
)

LISTERGEN_APIS=(${LISTERGEN_APIS[@]/#/$REPO_GO_PACKAGE/})
LISTERGEN_APIS=$(IFS=,; echo "${LISTERGEN_APIS[*]}")

${listergen} --input-dirs="${LISTERGEN_APIS}" --output-package="${REPO_GO_PACKAGE}/pkg/client/listers" --go-header-file="${BOILERPLATE_FILE}" "$@"

INFORMERGEN_APIS=(
$(
  cd ${REPO_ROOT}
  find pkg/apis -name types.go | xargs -n1 dirname | sort
)
)

INFORMERGEN_APIS=(${INFORMERGEN_APIS[@]/#/${REPO_GO_PACKAGE}/})
INFORMERGEN_APIS=$(IFS=,; echo "${INFORMERGEN_APIS[*]}")
${informergen} \
  --input-dirs "${INFORMERGEN_APIS}" \
  --versioned-clientset-package ${REPO_GO_PACKAGE}/pkg/client/clientset_generated/clientset \
  --internal-clientset-package ${REPO_GO_PACKAGE}/pkg/client/clientset_generated/internalclientset \
  --listers-package ${REPO_GO_PACKAGE}/pkg/client/listers \
  --output-package ${REPO_GO_PACKAGE}/pkg/client/informers/informers_generated \
  --go-header-file="${BOILERPLATE_FILE}" \
  "$@"

# You may add additional calls of code generators like set-gen above.
