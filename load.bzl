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

    # https://github.com/bazelbuild/bazel-skylib/releases
    if not native.existing_rule("bazel_skylib"):
        http_archive(
            name = "bazel_skylib",
            urls = [
                "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            ],
            sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        )

    # https://github.com/bazelbuild/bazel-toolchains/releases
    if not native.existing_rule("bazel_toolchains"):
        http_archive(
            name = "bazel_toolchains",
            sha256 = "1caf8584434d3e31be674067996be787cfa511fda2a0f05811131b588886477f",
            strip_prefix = "bazel-toolchains-3.7.2",
            urls = [
                "https://github.com/bazelbuild/bazel-toolchains/releases/download/3.7.2/bazel-toolchains-3.7.2.tar.gz",
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/3.7.2.tar.gz",
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

    # Check https://github.com/bazelbuild/rules_go/releases for new releases
    # v0.24.12 supports Golang 1.15.8
    # If this is updated, please ensure that bazel-toolchains is also updated
    if not native.existing_rule("io_bazel_rules_go"):
        http_archive(
            name = "io_bazel_rules_go",
            sha256 = "4d838e2d70b955ef9dd0d0648f673141df1bc1d7ecf5c2d621dcc163f47dd38a",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.12/rules_go-v0.24.12.tar.gz",
                "https://github.com/bazelbuild/rules_go/releases/download/v0.24.12/rules_go-v0.24.12.tar.gz",
            ],
            patch_args = ["-p1"],
            patches = [
                # Don't override TMPDIR in test runner.  See
                # https://github.com/bazelbuild/rules_go/issues/2776 for
                # details.
                "@io_k8s_repo_infra//third_party/io_bazel_rules_go:dont-set-TEST_TMPDIR-to-TMPDIR-in-the-test-runner.patch",
            ],
        )

    # https://github.com/bazelbuild/bazel-gazelle#running-gazelle-with-bazel
    if not native.existing_rule("bazel_gazelle"):
        http_archive(
            name = "bazel_gazelle",
            sha256 = "222e49f034ca7a1d1231422cdb67066b885819885c356673cb1f72f748a3c9d4",
            urls = [
                "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.3/bazel-gazelle-v0.22.3.tar.gz",
                "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.3/bazel-gazelle-v0.22.3.tar.gz",
            ],
        )

    # https://github.com/bazelbuild/rules_proto#getting-started
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

    # https://github.com/bazelbuild/buildtools/releases
    # TODO(fejta): kazel needs a fix for 3.0.0
    if not native.existing_rule("com_github_bazelbuild_buildtools"):
        http_archive(
            name = "com_github_bazelbuild_buildtools",
            sha256 = "a02ba93b96a8151b5d8d3466580f6c1f7e77212c4eb181cba53eb2cae7752a23",
            strip_prefix = "buildtools-3.5.0",
            urls = [
                "https://github.com/bazelbuild/buildtools/archive/3.5.0.tar.gz",
            ],
        )

    # https://github.com/bazelbuild/rules_nodejs/releases
    if not native.existing_rule("bazel_build_rules_nodejs"):
        http_archive(
            name = "build_bazel_rules_nodejs",
            sha256 = "d14076339deb08e5460c221fae5c5e9605d2ef4848eee1f0c81c9ffdc1ab31c1",
            urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/1.6.1/rules_nodejs-1.6.1.tar.gz"],
        )
