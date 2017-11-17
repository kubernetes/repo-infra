workspace(name = "io_kubernetes_build")

git_repository(
    name = "io_bazel_rules_go",
    commit = "f4bebf54dca2ad198b0311fd772c8100149cd647",
    remote = "https://github.com/bazelbuild/rules_go.git",
)

load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()

go_register_toolchains()
