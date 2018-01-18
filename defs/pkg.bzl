load(
    "@bazel_tools//tools/build_defs/pkg:pkg.bzl",
    _real_pkg_tar = "pkg_tar",
)

# pkg_tar wraps the official pkg_tar rule with our faster
# Go-based build_tar binary.
def pkg_tar(**kwargs):
    if "build_tar" not in kwargs:
        kwargs["build_tar"] = "@io_kubernetes_build//tools/build_tar"
    _real_pkg_tar(**kwargs)
