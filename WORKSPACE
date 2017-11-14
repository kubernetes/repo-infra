workspace(name = "io_kubernetes_build")

git_repository(
    name = "io_bazel_rules_go",
    commit = "b358831ed503659656daa35a361094a1eee5aa60",
    remote = "https://github.com/bazelbuild/rules_go.git",
)

load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()

go_register_toolchains()
