# gazelle:repository_macro repos.bzl%go_repositories
workspace(name = "io_k8s_repo_infra")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/0.8.0/bazel-skylib.0.8.0.tar.gz",
    ],
)

load("@bazel_skylib//lib:versions.bzl", "versions")

versions.check(minimum_bazel_version = "0.29.1")

http_archive(
    name = "bazel_toolchains",
    sha256 = "a019fbd579ce5aed0239de865b2d8281dbb809efd537bf42e0d366783e8dec65",
    strip_prefix = "bazel-toolchains-0.29.2",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/0.29.2.tar.gz",
        "https://github.com/bazelbuild/bazel-toolchains/archive/0.29.2.tar.gz",
    ],
)

load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")

rbe_autoconfig(name = "rbe_default")

http_archive(
    name = "com_google_protobuf",
    sha256 = "2ee9dcec820352671eb83e081295ba43f7a4157181dad549024d7070d079cf65",
    strip_prefix = "protobuf-3.9.0",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.9.0.tar.gz"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "ae8c36ff6e565f674c7a3692d6a9ea1096e4c1ade497272c2108a810fb39acd2",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/0.19.4/rules_go-0.19.4.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/0.19.4/rules_go-0.19.4.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "7fc87f4170011201b1690326e8c16c5d802836e3a0d617d8f75c3af2b23180c4",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("//:repos.bzl", "go_repositories")

go_repositories()
