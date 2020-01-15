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
            sha256 = "a653c9d318e42b14c0ccd7ac50c4a2a276c0db1e39743ab88b5aa2f0bc9cf607",
            strip_prefix = "bazel-toolchains-2.0.2",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/2.0.2.tar.gz",
                "https://github.com/bazelbuild/bazel-toolchains/archive/2.0.2.tar.gz",
            ],
        )

    if not native.existing_rule("com_google_protobuf"):
        http_archive(
            name = "com_google_protobuf",
            strip_prefix = "protobuf-3.11.2",
            urls = [
                "https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v3.11.2.tar.gz",
                "https://github.com/protocolbuffers/protobuf/archive/v3.11.2.tar.gz",
            ],
        )

    if not native.existing_rule("io_bazel_rules_go"):
        http_archive(
            name = "io_bazel_rules_go",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/v0.21.0/rules_go-v0.21.0.tar.gz",
                "https://github.com/bazelbuild/rules_go/releases/download/v0.21.0/rules_go-v0.21.0.tar.gz",
            ],
            sha256 = "b27e55d2dcc9e6020e17614ae6e0374818a3e3ce6f2024036e688ada24110444",
        )

    if not native.existing_rule("bazel_gazelle"):
        http_archive(
            name = "bazel_gazelle",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.19.1/bazel-gazelle-v0.19.1.tar.gz",
                "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.19.1/bazel-gazelle-v0.19.1.tar.gz",
            ],
            sha256 = "86c6d481b3f7aedc1d60c1c211c6f76da282ae197c3b3160f54bd3a8f847896f",
        )
