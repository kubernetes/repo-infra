package(default_visibility = ["//visibility:public"])

licenses(["notice"])

load(
    "@io_bazel_rules_go//go:def.bzl",
    "go_library",
    "go_test",
)

go_test(
    name = "github.com/bazelbuild/buildifier/core_test",
    srcs = [
        "parse_test.go",
        "print_test.go",
        "quote_test.go",
    ],
    library = ":github.com/bazelbuild/buildifier/core",
    tags = ["automanaged"],
)

go_library(
    name = "github.com/bazelbuild/buildifier/core",
    srcs = [
        "github.com/bazelbuild/buildifier/core/lex.go",
        "github.com/bazelbuild/buildifier/core/parse.y.go",
        "github.com/bazelbuild/buildifier/core/print.go",
        "github.com/bazelbuild/buildifier/core/quote.go",
        "github.com/bazelbuild/buildifier/core/rewrite.go",
        "github.com/bazelbuild/buildifier/core/rule.go",
        "github.com/bazelbuild/buildifier/core/syntax.go",
        "github.com/bazelbuild/buildifier/core/tables.go",
        "github.com/bazelbuild/buildifier/core/walk.go",
    ],
    tags = ["automanaged"],
)

go_library(
    name = "github.com/golang/glog",
    srcs = [
        "github.com/golang/glog/glog.go",
        "github.com/golang/glog/glog_file.go",
    ],
    tags = ["automanaged"],
)

go_library(
    name = "go/path/filepath",
    srcs = ["go/path/filepath/path.go"],
    tags = ["automanaged"],
)
