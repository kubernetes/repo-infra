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

# This figures out the host platform without relying on golang.  We need this as
# we don't want a golang install to be a prerequisite to building yet we need
# this info to figure out where the final binaries are placed.
repo::util::host_platform() {
  local host_os
  local host_arch
  case "$(uname -s)" in
    Darwin)
      host_os=darwin
      ;;
    Linux)
      host_os=linux
      ;;
    *)
      repo::log::error "Unsupported host OS.  Must be Linux or Mac OS X."
      exit 1
      ;;
  esac

  case "$(uname -m)" in
    x86_64*)
      host_arch=amd64
      ;;
    i?86_64*)
      host_arch=amd64
      ;;
    amd64*)
      host_arch=amd64
      ;;
    aarch64*)
      host_arch=arm64
      ;;
    arm64*)
      host_arch=arm64
      ;;
    arm*)
      host_arch=arm
      ;;
    i?86*)
      host_arch=x86
      ;;
    s390x*)
      host_arch=s390x
      ;;
    ppc64le*)
      host_arch=ppc64le
      ;;
    *)
      repo::log::error "Unsupported host arch. Must be x86_64, 386, arm, arm64, s390x or ppc64le."
      exit 1
      ;;
  esac
  echo "${host_os}/${host_arch}"
}

repo::util::find-binary-for-platform() {
  local -r lookfor="$1"
  local -r platform="$2"
  local locations=(
    "${REPO_ROOT}/_output/bin/${lookfor}"
    "${REPO_ROOT}/_output/dockerized/bin/${platform}/${lookfor}"
    "${REPO_ROOT}/_output/local/bin/${platform}/${lookfor}"
    "${REPO_ROOT}/platforms/${platform}/${lookfor}"
  )
  # Also search for binary in bazel build tree.
  # In some cases we have to name the binary $BINARY_bin, since there was a
  # directory named $BINARY next to it.
  locations+=($(find "${REPO_ROOT}/bazel-bin/" -type f -executable \
    \( -name "${lookfor}" -o -name "${lookfor}_bin" \) 2>/dev/null || true) )

  # List most recently-updated location.
  local -r bin=$( (ls -t "${locations[@]}" 2>/dev/null || true) | head -1 )
  echo -n "${bin}"
}

repo::util::find-binary() {
  repo::util::find-binary-for-platform "$1" "$(repo::util::host_platform)"
}

# Takes a group/version and returns the path to its location on disk, sans
# "pkg". E.g.:
# * default behavior: extensions/v1beta1 -> apis/extensions/v1beta1
# * default behavior for only a group: experimental -> apis/experimental
# * Special handling for empty group: v1 -> api/v1, unversioned -> api/unversioned
# * Special handling for groups suffixed with ".k8s.io": foo.k8s.io/v1 -> apis/foo/v1
# * Very special handling for when both group and version are "": / -> api
repo::util::group-version-to-pkg-path() {
  local group_version="$1"
  # Special cases first.
  # TODO(lavalamp): Simplify this by moving pkg/api/v1 and splitting pkg/api,
  # moving the results to pkg/apis/api.
  case "${group_version}" in
    # both group and version are "", this occurs when we generate deep copies for internal objects of the legacy v1 API.
    __internal)
      echo "pkg/api"
      ;;
    meta/v1)
      echo "vendor/k8s.io/apimachinery/pkg/apis/meta/v1"
      ;;
    meta/v1)
      echo "../vendor/k8s.io/apimachinery/pkg/apis/meta/v1"
      ;;
    *.k8s.io)
      echo "pkg/apis/${group_version%.*k8s.io}"
      ;;
    *.k8s.io/*)
      echo "pkg/apis/${group_version/.*k8s.io/}"
      ;;
    *)
      echo "pkg/apis/${group_version%__internal}"
      ;;
  esac
}

# ex: ts=2 sw=2 et filetype=sh
