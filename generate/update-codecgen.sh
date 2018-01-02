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

# The sort at the end makes sure we feed the topological sort a deterministic
# list (since there aren't many dependencies).

generated_files=($(
  #find ${REPO_ROOT} -not \( \
  #    \( \
  #      -wholename "${REPO_ROOT}/output" \
  #      -o -wholename "${REPO_ROOT}/_output" \
  #      -o -wholename "${REPO_ROOT}/staging" \
  #      -o -wholename "${REPO_ROOT}/release" \
  #      -o -wholename "${REPO_ROOT}/target" \
  #      -o -wholename '*/third_party/*' \
  #      -o -wholename '*/vendor/*' \
  #      -o -wholename '*/codecgen-*-1234.generated.go' \
  #      -o -wholename '*/repo-infra' \
  #    \) -prune \
  #  \) -name '*.generated.go' | LC_ALL=C sort -r))
  cd ${REPO_ROOT} && find . -not \( \
      \( \
        -wholename "./output" \
        -o -wholename "./_output" \
        -o -wholename "./staging" \
        -o -wholename "./release" \
        -o -wholename "./target" \
        -o -wholename '*/third_party/*' \
        -o -wholename '*/vendor/*' \
        -o -wholename '*/codecgen-*-1234.generated.go' \
      \) -prune \
    \) -name '*.generated.go' | LC_ALL=C sort -r))

# Register function to be called on EXIT to remove codecgen
# binary and also to touch the files that should be regenerated
# since they are first removed.
# This is necessary to make the script work after previous failure.
function cleanup {
  rm -f "${CODECGEN:-}"
  pushd "${REPO_ROOT}" > /dev/null
  for (( i=0; i < number; i++ )); do
    touch "${generated_files[${i}]}" || true
  done
  popd > /dev/null
}
trap cleanup EXIT

# Precompute dependencies for all directories.
# Then sort all files in the dependency order.
number=${#generated_files[@]}
result=""
for (( i=0; i<number; i++ )); do
  visited[${i}]=false
  # NB: go list *will* ignore the vendor directory unless the target file is in the go path, and thus may throw a bunch
  # of errors and not return any of the transitive dependencies, nor those in the vendor directory.  Ergo, we need to
  # use the "in-gopath" location for the files
  file="${GOPATH}/src/${REPO_GO_PACKAGE}/${generated_files[${i}]/\.generated\.go/.go}"
  deps[${i}]=$(cd ${REPO_ROOT} && go list -f '{{range .Deps}}{{.}}{{"\n"}}{{end}}' ${file} | grep "^${REPO_GO_PACKAGE}")
done
###echo "DBG: found $number generated files"
###for f in $(echo "${generated_files[@]}" | LC_ALL=C sort); do
###    echo "DBG:   $f"
###done

# NOTE: depends function assumes that the whole repository is under
# $my_prefix - it will NOT work if that is not true.
function depends {
  rhs="$(dirname ${generated_files[$2]/#./${REPO_GO_PACKAGE}})"
  ###echo "DBG: does ${file} depend on ${rhs}?"
  for dep in ${deps[$1]}; do
    ###echo "DBG:   checking against $dep"
    if [[ "${dep}" == "${rhs}" ]]; then
      ###echo "DBG: = yes"
      return 0
    fi
  done
  ###echo "DBG: = no"
  return 1
}

function tsort {
  visited[$1]=true
  local j=0
  for (( j=0; j<number; j++ )); do
    if ! ${visited[${j}]}; then
      if depends "$1" ${j}; then
        tsort $j
      fi
    fi
  done
  result="${result} $1"
}
echo "Building dependencies"
for (( i=0; i<number; i++ )); do
  ###echo "DBG: considering ${generated_files[${i}]}"
  if ! ${visited[${i}]}; then
    ###echo "DBG: tsorting ${generated_files[${i}]}"
    tsort ${i}
  fi
done
index=(${result})

haveindex=${index:-}
if [[ -z ${haveindex} ]]; then
  echo No files found for $0
  echo A previous run of $0 may have deleted all the files and then crashed.
  echo Use 'touch' to create files named 'types.generated.go' listed as deleted in 'git status'
  exit 1
fi

echo "Building codecgen"
# we *need* to run the Makefile with the repo root as the CWD
make -C ${REPO_ROOT} -f ${REPO_INFRA_ROOT}/Makefile generated_files
CODECGEN="${PWD}/codecgen_binary"
go build -o "${CODECGEN}" ./vendor/github.com/ugorji/go/codec/codecgen

# Running codecgen fails if some of the files doesn't compile.
# Thus (since all the files are completely auto-generated and
# not required for the code to be compilable, we first remove
# them and the regenerate them.
for (( i=0; i < number; i++ )); do
  rm -f "${generated_files[${i}]}"
done

# Generate files in the dependency order.
for current in "${index[@]}"; do
  generated_file=${generated_files[${current}]}
  initial_dir=${PWD}
  file=${generated_file/\.generated\.go/.go}
  # codecgen work only if invoked from directory where the file
  # is located.
  pushd "$(dirname ${file})" > /dev/null
  base_file=$(basename "${file}")
  base_generated_file=$(basename "${generated_file}")
  # We use '-d 1234' flag to have a deterministic output every time.
  # The constant was just randomly chosen.
  ###echo "DBG: running ${CODECGEN} -d 1234 -o ${base_generated_file} ${base_file}"
  ${CODECGEN} -d 1234 -o "${base_generated_file}" "${base_file}"
  # Add boilerplate at the beginning of the generated file.
  sed 's/YEAR/2016/' "${REPO_INFRA_ROOT}/verify/boilerplate/boilerplate.go.txt" > "${base_generated_file}.tmp"
  cat "${base_generated_file}" >> "${base_generated_file}.tmp"
  mv "${base_generated_file}.tmp" "${base_generated_file}"
  popd > /dev/null
done
