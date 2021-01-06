# Copyright 2021 The Kubernetes Authors.
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

"""
Workspace rule for binary installation of golangci-lint. This tool links
hundreds of dependencies, so using the binary release avoids dependency
management toil.
"""

_VERSION = "1.34.1"

_PLATFORMS = [
    struct(
        os = "darwin",
        arch = "amd64",
        sha256 = "6c3d87f9f6bccd5954de9954c1e75d7b521abdcc956e0643929a75cbf4c00aad",
    ),
    struct(
        os = "linux",
        arch = "amd64",
        sha256 = "23e4a9d8f89729007c6d749c245f725c2dbcfb194f4099003f9b826f1d386ad1",
    ),
    struct(
        os = "linux",
        arch = "arm64",
        sha256 = "3bdfb7e619c665878d90cb73d45b35e8af6d753421cb8be07c40b63f3215bb02",
    ),
    struct(
        os = "windows",
        arch = "amd64",
        sha256 = "04473b63ee17374e7a55fd7ebe7fe97bc510ae9883e9214798dae8e67de4ba48",
    ),
]

_URL_TMPL = "https://github.com/golangci/golangci-lint/releases/download/v{version}/golangci-lint-{version}-{os}-{arch}.{ext}"

_PLATFORM_ARCHIVE_FTYPE = {
    "darwin": "tar.gz",
    "linux": "tar.gz",
    "windows": "zip",
}

_BUILD_FILE = """
load("@io_k8s_repo_infra//defs:private/gcilint_repository.bzl", "gci_lint_alias")

gci_lint_alias()
"""

def _gci_lint_repository_impl(ctx):
    for platform in _PLATFORMS:
        ctx.download_and_extract(
            url = _URL_TMPL.format(
                os = platform.os,
                arch = platform.arch,
                version = _VERSION,
                ext = _PLATFORM_ARCHIVE_FTYPE[platform.os],
            ),
            output = platform.os + "_" + platform.arch,
            stripPrefix = "golangci-lint-{version}-{os}-{arch}".format(
                os = platform.os,
                arch = platform.arch,
                version = _VERSION,
            ),
            type = _PLATFORM_ARCHIVE_FTYPE[platform.os],
            sha256 = platform.sha256,
        )

    ctx.file("BUILD.bazel", content = _BUILD_FILE)

gci_lint_repository = repository_rule(
    implementation = _gci_lint_repository_impl,
)

def gci_lint_alias():
    native.alias(
        name = "golangci-lint",
        actual = select({
            "@io_bazel_rules_go//go/platform:darwin_amd64": "darwin_amd64/golangci-lint",
            "@io_bazel_rules_go//go/platform:linux_arm64": "linux_arm64/golangci-lint",
            "@io_bazel_rules_go//go/platform:linux_amd64": "linux_amd64/golangci-lint",
            "@io_bazel_rules_go//go/platform:windows_amd64": "windows_amd64/golangci-lint",
            "//conditions:default": ":UNKNOWN_PLATFORM_FOR_GOLANGCI",
        }),
        visibility = ["//visibility:public"],
    )
