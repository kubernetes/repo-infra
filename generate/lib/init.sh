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

# these scripts are intended to be run as a subdirectory
# of the repo:
# <repo>/repo-infra/generate/init.sh

# try to find the root of the repository
# assume we're in vendor and make sure that's ok
if [[ -z "${REPO_ROOT:-}" ]]; then
    assumed_vendor_root=$(cd "$(dirname "${BASH_SOURCE}")/../../../../.." && pwd -P)
    if [[ -e "${assumed_vendor_root}/vendor/k8s.io/repo-infra" ]]; then
        REPO_ROOT=$(cd "${assumed_vendor_root}" && pwd -P)
    else
        echo "Unable to determine repo root -- is k8s.io/repo-infra in the vendor directory?"
        exit 1
    fi
fi

REPO_INFRA_ROOT="${REPO_ROOT}/vendor/k8s.io/repo-infra"
REPO_LIB_ROOT="${REPO_ROOT}/vendor/k8s.io/repo-infra/generate/lib/"

# source repository-specific configuration
source "${REPO_ROOT}/repo-infra-config.sh"

# TODO: source these from a repo-specific init file?
REPO_AVAILABLE_GROUP_VERSIONS="${REPO_AVAILABLE_GROUP_VERSIONS:?no available group versions set}"
REPO_NO_CLIENT_GROUP_VERSIONS="${REPO_NO_CLIENT_GROUP_VERSIONS:-}"

# needed for building?
# The root of the build/dist directory
REPO_OUTPUT_SUBPATH="${REPO_OUTPUT_SUBPATH:-_output/local}"
REPO_OUTPUT="${REPO_ROOT}/${REPO_OUTPUT_SUBPATH}"
REPO_OUTPUT_BINPATH="${REPO_OUTPUT}/bin"

# This is a symlink to binaries for "this platform", e.g. build tools.
THIS_PLATFORM_BIN="${REPO_ROOT}/_output/bin"

# initialization and utility
source "${REPO_LIB_ROOT}/util.sh"

# TODO: do we need these?
source "${REPO_LIB_ROOT}/logging.sh"

# TODO: do we need this?
repo::log::install_errexit

source "${REPO_LIB_ROOT}/version.sh"
source "${REPO_LIB_ROOT}/golang.sh"

REPO_OUTPUT_HOSTBIN="${REPO_OUTPUT_BINPATH}/$(repo::util::host_platform)"

# This emulates "readlink -f" which is not available on MacOS X.
# Test:
# T=/tmp/$$.$RANDOM
# mkdir $T
# touch $T/file
# mkdir $T/dir
# ln -s $T/file $T/linkfile
# ln -s $T/dir $T/linkdir
# function testone() {
#   X=$(readlink -f $1 2>&1)
#   Y=$(repo::readlinkdashf $1 2>&1)
#   if [ "$X" != "$Y" ]; then
#     echo readlinkdashf $1: expected "$X", got "$Y"
#   fi
# }
# testone /
# testone /tmp
# testone $T
# testone $T/file
# testone $T/dir
# testone $T/linkfile
# testone $T/linkdir
# testone $T/nonexistant
# testone $T/linkdir/file
# testone $T/linkdir/dir
# testone $T/linkdir/linkfile
# testone $T/linkdir/linkdir
function repo::readlinkdashf {
  # run in a subshell for simpler 'cd'
  (
    if [[ -d "$1" ]]; then # This also catch symlinks to dirs.
      cd "$1"
      pwd -P
    else
      cd $(dirname "$1")
      local f
      f=$(basename "$1")
      if [[ -L "$f" ]]; then
        readlink "$f"
      else
        echo "$(pwd -P)/${f}"
      fi
    fi
  )
}

# This emulates "realpath" which is not available on MacOS X
# Test:
# T=/tmp/$$.$RANDOM
# mkdir $T
# touch $T/file
# mkdir $T/dir
# ln -s $T/file $T/linkfile
# ln -s $T/dir $T/linkdir
# function testone() {
#   X=$(realpath $1 2>&1)
#   Y=$(repo::realpath $1 2>&1)
#   if [ "$X" != "$Y" ]; then
#     echo realpath $1: expected "$X", got "$Y"
#   fi
# }
# testone /
# testone /tmp
# testone $T
# testone $T/file
# testone $T/dir
# testone $T/linkfile
# testone $T/linkdir
# testone $T/nonexistant
# testone $T/linkdir/file
# testone $T/linkdir/dir
# testone $T/linkdir/linkfile
# testone $T/linkdir/linkdir
repo::realpath() {
  if [[ ! -e "$1" ]]; then
    echo "$1: No such file or directory" >&2
    return 1
  fi
  repo::readlinkdashf "$1"
}

# -- begin unfiltered stuff from Kube

# The root of the build/dist directory
#KUBE_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/../.." && pwd -P)"
#
#KUBE_OUTPUT_SUBPATH="${KUBE_OUTPUT_SUBPATH:-_output/local}"
#KUBE_OUTPUT="${KUBE_ROOT}/${KUBE_OUTPUT_SUBPATH}"
#KUBE_OUTPUT_BINPATH="${KUBE_OUTPUT}/bin"
#
## This controls rsync compression. Set to a value > 0 to enable rsync
## compression for build container
#KUBE_RSYNC_COMPRESS="${KUBE_RSYNC_COMPRESS:-0}"
#
## Set no_proxy for localhost if behind a proxy, otherwise,
## the connections to localhost in scripts will time out
#export no_proxy=127.0.0.1,localhost
#
## This is a symlink to binaries for "this platform", e.g. build tools.
#THIS_PLATFORM_BIN="${KUBE_ROOT}/_output/bin"
#
#source "${KUBE_ROOT}/hack/lib/util.sh"
#source "${KUBE_ROOT}/cluster/lib/util.sh"
#source "${KUBE_ROOT}/cluster/lib/logging.sh"
#
#repo::log::install_errexit
#
#source "${KUBE_ROOT}/hack/lib/version.sh"
#source "${KUBE_ROOT}/hack/lib/golang.sh"
#source "${KUBE_ROOT}/hack/lib/etcd.sh"
#
#KUBE_OUTPUT_HOSTBIN="${KUBE_OUTPUT_BINPATH}/$(repo::util::host_platform)"
#
## list of all available group versions.  This should be used when generated code
## or when starting an API server that you want to have everything.
## most preferred version for a group should appear first
#KUBE_AVAILABLE_GROUP_VERSIONS="${KUBE_AVAILABLE_GROUP_VERSIONS:-\
#v1 \
#apps/v1beta1 \
#authentication.k8s.io/v1beta1 \
#authorization.k8s.io/v1beta1 \
#autoscaling/v1 \
#autoscaling/v2alpha1 \
#batch/v1 \
#batch/v2alpha1 \
#certificates.k8s.io/v1beta1 \
#extensions/v1beta1 \
#imagepolicy.k8s.io/v1alpha1 \
#policy/v1beta1 \
#rbac.authorization.k8s.io/v1beta1 \
#rbac.authorization.k8s.io/v1alpha1 \
#storage.k8s.io/v1beta1\
#}"
#
## not all group versions are exposed by the server.  This list contains those
## which are not available so we don't generate clients or swagger for them
#KUBE_NONSERVER_GROUP_VERSIONS="
# abac.authorization.kubernetes.io/v0 \
# abac.authorization.kubernetes.io/v1beta1 \
# componentconfig/v1alpha1 \
# imagepolicy.k8s.io/v1alpha1\
#"
#
## This emulates "readlink -f" which is not available on MacOS X.
## Test:
## T=/tmp/$$.$RANDOM
## mkdir $T
## touch $T/file
## mkdir $T/dir
## ln -s $T/file $T/linkfile
## ln -s $T/dir $T/linkdir
## function testone() {
##   X=$(readlink -f $1 2>&1)
##   Y=$(repo::readlinkdashf $1 2>&1)
##   if [ "$X" != "$Y" ]; then
##     echo readlinkdashf $1: expected "$X", got "$Y"
##   fi
## }
## testone /
## testone /tmp
## testone $T
## testone $T/file
## testone $T/dir
## testone $T/linkfile
## testone $T/linkdir
## testone $T/nonexistant
## testone $T/linkdir/file
## testone $T/linkdir/dir
## testone $T/linkdir/linkfile
## testone $T/linkdir/linkdir
#function repo::readlinkdashf {
#  # run in a subshell for simpler 'cd'
#  (
#    if [[ -d "$1" ]]; then # This also catch symlinks to dirs.
#      cd "$1"
#      pwd -P
#    else
#      cd $(dirname "$1")
#      local f
#      f=$(basename "$1")
#      if [[ -L "$f" ]]; then
#        readlink "$f"
#      else
#        echo "$(pwd -P)/${f}"
#      fi
#    fi
#  )
#}
#
## This emulates "realpath" which is not available on MacOS X
## Test:
## T=/tmp/$$.$RANDOM
## mkdir $T
## touch $T/file
## mkdir $T/dir
## ln -s $T/file $T/linkfile
## ln -s $T/dir $T/linkdir
## function testone() {
##   X=$(realpath $1 2>&1)
##   Y=$(repo::realpath $1 2>&1)
##   if [ "$X" != "$Y" ]; then
##     echo realpath $1: expected "$X", got "$Y"
##   fi
## }
## testone /
## testone /tmp
## testone $T
## testone $T/file
## testone $T/dir
## testone $T/linkfile
## testone $T/linkdir
## testone $T/nonexistant
## testone $T/linkdir/file
## testone $T/linkdir/dir
## testone $T/linkdir/linkfile
## testone $T/linkdir/linkdir
#repo::realpath() {
#  if [[ ! -e "$1" ]]; then
#    echo "$1: No such file or directory" >&2
#    return 1
#  fi
#  repo::readlinkdashf "$1"
#}

