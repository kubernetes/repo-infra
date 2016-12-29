package(default_visibility = ["//visibility:public"])

licenses(["notice"])

load(
    "@io_bazel_rules_go//go:def.bzl",
    "go_binary",
    "go_library",
)

go_binary(
    name = "gazel",
    library = ":go_default_library",
    tags = ["automanaged"],
)

go_library(
    name = "go_default_library",
    srcs = [
        "config.go",
        "diff.go",
        "gazel.go",
        "sourcerer.go",
    ],
    tags = ["automanaged"],
    deps = [
        "//vendor:github.com/bazelbuild/buildifier/core",
        "//vendor:github.com/golang/glog",
        "//vendor:go/path/filepath",
    ],
)
