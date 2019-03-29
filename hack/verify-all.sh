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

set -o errexit
set -o nounset
set -o pipefail

cd "$(git rev-parse --show-toplevel)"
errs=()
for sh in $(ls hack/verify* | grep -v verify-all); do
  "./$sh" && echo "PASS: $sh" && continue
  echo "FAIL: $sh"
  errs+=("$sh")
done
if [[ ${#errs[@]} -eq 0 ]]; then
  echo "PASS"
  exit 0
fi
echo "FAILED ${#errs[@]} checks:" >&2
for e in "${errs[@]}"; do
  echo "  $e" >&2
done
exit 1
