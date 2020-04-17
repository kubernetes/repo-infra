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
            sha256 = "239a1a673861eabf988e9804f45da3b94da28d1aff05c373b013193c315d9d9e",
            strip_prefix = "bazel-toolchains-3.0.1",
            urls = [
                "https://github.com/bazelbuild/bazel-toolchains/releases/download/3.0.1/bazel-toolchains-3.0.1.tar.gz",
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/3.0.1.tar.gz",
            ],
        )

    if not native.existing_rule("com_google_protobuf"):
        http_archive(
            name = "com_google_protobuf",
            sha256 = "a79d19dcdf9139fa4b81206e318e33d245c4c9da1ffed21c87288ed4380426f9",
            strip_prefix = "protobuf-3.11.4",
            urls = [
                "https://mirror.bazel.build/github.com/protocolbuffers/protobuf/archive/v3.11.4.tar.gz",
                "https://github.com/protocolbuffers/protobuf/archive/v3.11.4.tar.gz",
            ],
        )

    if not native.existing_rule("io_bazel_rules_go"):
        http_archive(
            name = "io_bazel_rules_go",
            sha256 = "7b9bbe3ea1fccb46dcfa6c3f3e29ba7ec740d8733370e21cdc8937467b4a4349",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.22.4/rules_go-v0.22.4.tar.gz",
                "https://github.com/bazelbuild/rules_go/releases/download/v0.22.4/rules_go-v0.22.4.tar.gz",
            ],
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

    if not native.existing_rule("rules_proto"):
        http_archive(
            name = "rules_proto",
            sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
            strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
                "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
            ],
        )

    if not native.existing_rule("com_github_bazelbuild_buildtools"):
        http_archive(
            name = "com_github_bazelbuild_buildtools",
            sha256 = "7e9603607769f48e67dad0b04c1311484fc437a989405acc8462f3aa68e50eb0",
            strip_prefix = "buildtools-2.2.1",
            urls = [
                "https://github.com/bazelbuild/buildtools/archive/2.2.1.tar.gz",
            ],
        )

    if not native.existing_rule("bazel_build_rules_nodejs"):
        http_archive(
            name = "build_bazel_rules_nodejs",
            sha256 = "f9e7b9f42ae202cc2d2ce6d698ccb49a9f7f7ea572a78fd451696d03ef2ee116",
            urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/1.6.0/rules_nodejs-1.6.0.tar.gz"],
        )
