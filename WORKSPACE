workspace(name = "io_k8s_repo_infra")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "6776d68ebb897625dead17ae510eac3d5f6342367327875210df44dbe2aeeb19",
    url = "https://github.com/bazelbuild/rules_go/releases/download/0.17.1/rules_go-0.17.1.tar.gz",
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "3c681998538231a2d24d0c07ed5a7658cb72bfb5fd4bf9911157c0e9ac6a2687",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.17.0/bazel-gazelle-0.17.0.tar.gz"],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

gazelle_dependencies()

http_archive(
    name = "io_bazel",
    sha256 = "6860a226c8123770b122189636fb0c156c6e5c9027b5b245ac3b2315b7b55641",
    url = "https://github.com/bazelbuild/bazel/releases/download/0.22.0/bazel-0.22.0-dist.zip",
)

go_repository(
    name = "com_github_bazelbuild_bazel_gazelle",
    commit = "cdeedbd62467",
    importpath = "github.com/bazelbuild/bazel-gazelle",
)

go_repository(
    name = "com_github_bazelbuild_buildtools",
    commit = "80c7f0d45d7e",
    importpath = "github.com/bazelbuild/buildtools",
)

go_repository(
    name = "com_github_burntsushi_toml",
    importpath = "github.com/BurntSushi/toml",
    tag = "v0.3.0",
)

go_repository(
    name = "com_github_davecgh_go_spew",
    importpath = "github.com/davecgh/go-spew",
    tag = "v1.1.0",
)

go_repository(
    name = "com_github_fsnotify_fsnotify",
    importpath = "github.com/fsnotify/fsnotify",
    tag = "v1.4.7",
)

go_repository(
    name = "com_github_golang_protobuf",
    importpath = "github.com/golang/protobuf",
    tag = "v1.3.1",
)

go_repository(
    name = "com_github_pelletier_go_toml",
    importpath = "github.com/pelletier/go-toml",
    tag = "v1.1.0",
)

go_repository(
    name = "com_github_pmezard_go_difflib",
    importpath = "github.com/pmezard/go-difflib",
    tag = "v1.0.0",
)

go_repository(
    name = "in_gopkg_check_v1",
    commit = "20d25e280405",
    importpath = "gopkg.in/check.v1",
)

go_repository(
    name = "in_gopkg_yaml_v2",
    importpath = "gopkg.in/yaml.v2",
    tag = "v2.2.1",
)

go_repository(
    name = "io_k8s_klog",
    commit = "b9b56d5dfc92",
    importpath = "k8s.io/klog",
)

go_repository(
    name = "org_golang_x_build",
    commit = "125f04e1fc4b",
    importpath = "golang.org/x/build",
)

go_repository(
    name = "org_golang_x_sys",
    commit = "8469e314837c",
    importpath = "golang.org/x/sys",
)

go_repository(
    name = "org_golang_x_tools",
    commit = "77106db15f68",
    importpath = "golang.org/x/tools",
)
