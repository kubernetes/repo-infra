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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repositories():
    if not native.existing_rule("subpar"):
        http_archive(
            name = "subpar",
            urls = ["https://github.com/google/subpar/archive/2.0.0.tar.gz"],
            sha256 = "b80297a1b8d38027a86836dbadc22f55dc3ecad56728175381aa6330705ac10f",
            strip_prefix = "subpar-2.0.0",
        )
    if not native.existing_rule("bazel_skylib"):
        http_archive(
            name = "bazel_skylib",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
                "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            ],
            sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
        )

    if not native.existing_rule("bazel_toolchains"):
        http_archive(
            name = "bazel_toolchains",
            sha256 = "4d348abfaddbcee0c077fc51bb1177065c3663191588ab3d958f027cbfe1818b",
            strip_prefix = "bazel-toolchains-2.1.0",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/2.1.0.tar.gz",
                "https://github.com/bazelbuild/bazel-toolchains/archive/2.1.0.tar.gz",
            ],
        )

    if not native.existing_rule("com_google_protobuf"):
        http_archive(
            name = "com_google_protobuf",
            strip_prefix = "protobuf-3.11.3",
            sha256 = "cf754718b0aa945b00550ed7962ddc167167bd922b842199eeb6505e6f344852",
            urls = [
                "https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v3.11.3.tar.gz",
                "https://github.com/protocolbuffers/protobuf/archive/v3.11.3.tar.gz",
            ],
        )

    if not native.existing_rule("io_bazel_rules_go"):
        http_archive(
            name = "io_bazel_rules_go",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/v0.21.2/rules_go-v0.21.2.tar.gz",
                "https://github.com/bazelbuild/rules_go/releases/download/v0.21.2/rules_go-v0.21.2.tar.gz",
            ],
            sha256 = "f99a9d76e972e0c8f935b2fe6d0d9d778f67c760c6d2400e23fc2e469016e2bd",
        )

    if not native.existing_rule("bazel_gazelle"):
        http_archive(
            name = "bazel_gazelle",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.20.0/bazel-gazelle-v0.20.0.tar.gz",
                "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.20.0/bazel-gazelle-v0.20.0.tar.gz",
            ],
            sha256 = "d8c45ee70ec39a57e7a05e5027c32b1576cc7f16d9dd37135b0eddde45cf1b10",
        )
