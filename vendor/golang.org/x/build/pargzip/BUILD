load("@io_bazel_rules_go//go:def.bzl", "go_library", "go_test")

go_library(
    name = "go_default_library",
    srcs = ["pargzip.go"],
    importpath = "golang.org/x/build/pargzip",
    visibility = ["//visibility:public"],
)

go_test(
    name = "go_default_test",
    srcs = ["pargzip_test.go"],
    importpath = "golang.org/x/build/pargzip",
    library = ":go_default_library",
)
