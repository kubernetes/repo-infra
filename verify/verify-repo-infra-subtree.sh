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

set -eu
set -o pipefail

[ -n "${DEBUG:-}" ] && set -x

readonly TEMP_NAME="temp-repo-infra-${RANDOM}"
readonly REPO_ROOT="$( git rev-parse --show-toplevel )"
readonly UPSTREAM_URL="${REPO_INFRA_URL:-git@github.com:kubernetes/repo-infra}"
readonly UPSTREAM_REV="${REPO_INFRA_REV:-master}"

readlinkf() {
  perl -MCwd -e 'print Cwd::abs_path shift' "$1"
}

targetPath="${REPO_INFRA_PATH:-}"
[ -z "$targetPath" ] && {
  targetPath="$(
    cd "$(readlinkf "${0}/../..")" \
      && git rev-parse --show-prefix
  )"
}
readonly targetPath
[ -z "$targetPath" ] && {
  {
    echo 'Could not determine where repo-infra has been added.'
    # shellcheck disable=SC2016
    echo 'You can specifically configure that by setting $REPO_INFRA_TARGET.'
  } >&2
  exit 2
}

quietGit() {
  local stdout stderr rc
  stdout="$(mktemp)"
  stderr="$(mktemp)"

  set +e
    git "$@" </dev/null >"$stdout" 2>"$stderr"
    rc=$?
  set -e

  [ $rc -ne 0 ] && {
    cat "$stdout"
    cat "$stderr" >&2
  }

  rm -f -- "$stdout" "$stderr"
  return $rc
}

addTempRemote() {
  quietGit remote add "$TEMP_NAME" "$UPSTREAM_URL"
  quietGit fetch "$TEMP_NAME"
}

forkTempBranch() {
  local orgBranch
  orgBranch="$( git rev-parse --abbrev-ref HEAD )"
  quietGit checkout -b "$TEMP_NAME"
  echo "$orgBranch"
}

delTempRemote() {
  quietGit remote remove "$TEMP_NAME"
}

resetForkedBranch() {
  local oldBranch="$1"
  quietGit reset
  quietGit checkout "$oldBranch"
  quietGit branch -D "$TEMP_NAME"
}

updateRepoInfra() {
  quietGit subtree pull --prefix "$targetPath" "$TEMP_NAME" "$UPSTREAM_REV" --squash
}

update() {
  cd "$REPO_ROOT"
  trap delTempRemote EXIT

  addTempRemote
  updateRepoInfra
}

verify() {
  local orgRev newRev

  cd "$REPO_ROOT"

  addTempRemote
  trap delTempRemote EXIT

  orgBranch="$( forkTempBranch )"
  trap 'resetForkedBranch "$orgBranch"; delTempRemote' EXIT

  orgRev="$( git rev-parse HEAD )"
  updateRepoInfra
  newRev="$( git rev-parse HEAD )"

  [ "$orgRev" = "$newRev" ] || {
    {
      echo "${targetPath} out of sync with ${UPSTREAM_URL}"
      echo
      git diff --stat "$orgRev"
    } >&2
    return 1
  }
}

main() {
  case "$0" in
    *update*)   update ;;
    *verify*)   verify ;;
    *)          echo 'unsupported mode' >&2 ; return 3 ;;
  esac
}

main "$@"
