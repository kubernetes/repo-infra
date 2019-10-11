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
            sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
            urls = [
                "https://github.com/bazelbuild/bazel-skylib/releases/download/0.8.0/bazel-skylib.0.8.0.tar.gz",
            ],
        )

    if not native.existing_rule("bazel_toolchains"):
        http_archive(
            name = "bazel_toolchains",
            sha256 = "e9bab54199722935f239cb1cd56a80be2ac3c3843e1a6d3492e2bc11f9c21daf",
            strip_prefix = "bazel-toolchains-1.0.0",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/1.0.0.tar.gz",
                "https://github.com/bazelbuild/bazel-toolchains/archive/1.0.0.tar.gz",
            ],
        )

    if not native.existing_rule("com_google_protobuf"):
        http_archive(
            name = "com_google_protobuf",
            sha256 = "2ee9dcec820352671eb83e081295ba43f7a4157181dad549024d7070d079cf65",
            strip_prefix = "protobuf-3.9.0",
            urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.9.0.tar.gz"],
        )

    if not native.existing_rule("io_bazel_rules_go"):
        http_archive(
            name = "io_bazel_rules_go",
            sha256 = "ae8c36ff6e565f674c7a3692d6a9ea1096e4c1ade497272c2108a810fb39acd2",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/0.19.4/rules_go-0.19.4.tar.gz",
                "https://github.com/bazelbuild/rules_go/releases/download/0.19.4/rules_go-0.19.4.tar.gz",
            ],
        )

    if not native.existing_rule("bazel_gazelle"):
        http_archive(
            name = "bazel_gazelle",
            sha256 = "7fc87f4170011201b1690326e8c16c5d802836e3a0d617d8f75c3af2b23180c4",
            urls = [
                "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
                "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
            ],
        )
