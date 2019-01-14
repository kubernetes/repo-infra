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

readonly WORKSPACE="$( mktemp -d )"
trap 'rm -rf -- "$WORKSPACE"' EXIT

[ "${TRAVIS:-}" = 'true' ] && {
  git checkout "$BRANCH_TO_MERGE"
}

readonly REPO_INFRA_ROOT="$( git rev-parse --show-toplevel )"
readonly REPO_INFRA_PATH="tools/repo-infra"
readonly REPO_INFRA_REV="$( git rev-parse 'HEAD' )"
readonly REPO_INFRA_REV_PARENT="$( git rev-parse 'HEAD^' )"

# Will be picked up by the {verify,update}-repo-infra-subtree.sh scripts
export REPO_INFRA_REV
export REPO_INFRA_URL="$REPO_INFRA_ROOT"
# Just print to stdout, don't use any interactive tools (less, most, ...)
unset PAGER

fail() {
  echo '[FAIL]' "$@"
  return 1
}

STEP() {
  echo '[step]' "$@"
}

runTest() {
  local t="${1}"
  echo "[--] running '${t}'"
  "$@"
  echo "[OK] '${t}' succeeded"
}

test_add_verify_update() {
  cd "$WORKSPACE"

  local rc out
  local verify="${REPO_INFRA_PATH}/verify/verify-repo-infra-subtree.sh"
  local update="${REPO_INFRA_PATH}/verify/update-repo-infra-subtree.sh"

  STEP creating a dummy repo
    git init .
    echo 'this is the README' >> README
    git add README
    git commit -m 'initial commit: add README'

    test ! -e "$verify" || fail "Expected '${verify}' not to exist"
    test ! -e "$update" || fail "Expected '${update}' not to exist"

  STEP subtree adding an older version of repo-infra
    git remote add "repo-infra-init" "$REPO_INFRA_URL"
    git fetch "repo-infra-init"
    git subtree add -P "$REPO_INFRA_PATH" "repo-infra-init" "$REPO_INFRA_REV_PARENT" --squash
    git remote remove "repo-infra-init"

    test -e "$verify" || fail "Expected '${verify}' to exist"
    test -e "$update" || fail "Expected '${update}' to exist"

  STEP running verify, which should fail
    rc=0
    out="$( "$verify" 2>&1 )" || rc=$?

    test $rc -ne 0 || fail "Expected exit code of verify not to be 0"
    test "$out" != '' || fail "Expected output of verify not to be empty"

  STEP running update
    rc=0
    out="$( "$update" 2>&1 )" || rc=$?

    test $rc -eq 0 || fail "Expected exit code of update to be 0"
    test "$out" = '' || fail "Expected output of update to be empty"

  STEP running verify again, which should now succeed
    rc=0
    out="$( "$verify" 2>&1 )" || rc=$?

    test $rc -eq 0 || fail "Expected exit code of verify to be 0"
    test "$out" = '' || fail "Expected output of verify to be empty"
}

main() {
  runTest test_add_verify_update
}

main "$@"
