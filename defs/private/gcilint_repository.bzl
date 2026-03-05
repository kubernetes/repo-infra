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

_VERSION = "1.64.8"

_PLATFORMS = [
    struct(
        os = "darwin",
        arch = "amd64",
        sha256 = "b52aebb8cb51e00bfd5976099083fbe2c43ef556cef9c87e58a8ae656e740444",
    ),
    struct(
        os = "darwin",
        arch = "arm64",
        sha256 = "70543d21e5b02a94079be8aa11267a5b060865583e337fe768d39b5d3e2faf1f",
    ),
    struct(
        os = "linux",
        arch = "amd64",
        sha256 = "b6270687afb143d019f387c791cd2a6f1cb383be9b3124d241ca11bd3ce2e54e",
    ),
    struct(
        os = "linux",
        arch = "arm64",
        sha256 = "a6ab58ebcb1c48572622146cdaec2956f56871038a54ed1149f1386e287789a5",
    ),
    struct(
        os = "windows",
        arch = "amd64",
        sha256 = "54c2ed3a6b4f2f5da1056fb6e83d6b73b592e06684b65a5999174fabbb251a8f",
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
            "@io_bazel_rules_go//go/platform:darwin_arm64": "darwin_arm64/golangci-lint",
            "@io_bazel_rules_go//go/platform:linux_arm64": "linux_arm64/golangci-lint",
            "@io_bazel_rules_go//go/platform:linux_amd64": "linux_amd64/golangci-lint",
            "@io_bazel_rules_go//go/platform:windows_amd64": "windows_amd64/golangci-lint",
            "//conditions:default": ":UNKNOWN_PLATFORM_FOR_GOLANGCI",
        }),
        visibility = ["//visibility:public"],
    )
