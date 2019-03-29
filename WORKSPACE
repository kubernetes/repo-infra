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

go_register_toolchains(
    nogo = "@//:nogo_vet",
)

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
    tag = "v0.3.1",
)

go_repository(
    name = "com_github_davecgh_go_spew",
    importpath = "github.com/davecgh/go-spew",
    tag = "v1.1.1",
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
    commit = "788fd7840127",
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
    commit = "379209517ffe",
    importpath = "golang.org/x/tools",
)

go_repository(
    name = "com_github_alecthomas_gometalinter",
    importpath = "github.com/alecthomas/gometalinter",
    tag = "v3.0.0",
)

go_repository(
    name = "com_github_alecthomas_units",
    commit = "2efee857e7cf",
    importpath = "github.com/alecthomas/units",
)

go_repository(
    name = "com_github_google_shlex",
    commit = "c34317bd91bf",
    importpath = "github.com/google/shlex",
)

go_repository(
    name = "com_github_nicksnyder_go_i18n",
    importpath = "github.com/nicksnyder/go-i18n",
    tag = "v1.10.0",
)

go_repository(
    name = "com_github_stretchr_objx",
    importpath = "github.com/stretchr/objx",
    tag = "v0.1.0",
)

go_repository(
    name = "com_github_stretchr_testify",
    importpath = "github.com/stretchr/testify",
    tag = "v1.3.0",
)

go_repository(
    name = "in_gopkg_alecthomas_kingpin_v3_unstable",
    commit = "df19058c872c",
    importpath = "gopkg.in/alecthomas/kingpin.v3-unstable",
)

go_repository(
    name = "cc_mvdan_interfacer",
    commit = "c20040233aed",
    importpath = "mvdan.cc/interfacer",
)

go_repository(
    name = "cc_mvdan_lint",
    commit = "adc824a0674b",
    importpath = "mvdan.cc/lint",
)

go_repository(
    name = "cc_mvdan_unparam",
    commit = "fbb59629db34",
    importpath = "mvdan.cc/unparam",
)

go_repository(
    name = "com_github_fatih_color",
    importpath = "github.com/fatih/color",
    tag = "v1.6.0",
)

go_repository(
    name = "com_github_go_critic_go_critic",
    commit = "ee9bf5809ead",
    importpath = "github.com/go-critic/go-critic",
)

go_repository(
    name = "com_github_go_lintpack_lintpack",
    importpath = "github.com/go-lintpack/lintpack",
    tag = "v0.5.2",
)

go_repository(
    name = "com_github_go_ole_go_ole",
    importpath = "github.com/go-ole/go-ole",
    tag = "v1.2.1",
)

go_repository(
    name = "com_github_go_toolsmith_astcast",
    commit = "b7a89ed70af1",
    importpath = "github.com/go-toolsmith/astcast",
)

go_repository(
    name = "com_github_go_toolsmith_astcopy",
    commit = "79b422d080c4",
    importpath = "github.com/go-toolsmith/astcopy",
)

go_repository(
    name = "com_github_go_toolsmith_astequal",
    commit = "dcb477bfacd6",
    importpath = "github.com/go-toolsmith/astequal",
)

go_repository(
    name = "com_github_go_toolsmith_astfmt",
    commit = "8f8ee99c3086",
    importpath = "github.com/go-toolsmith/astfmt",
)

go_repository(
    name = "com_github_go_toolsmith_astp",
    commit = "0af7e3c24f30",
    importpath = "github.com/go-toolsmith/astp",
)

go_repository(
    name = "com_github_go_toolsmith_pkgload",
    commit = "e9e65178eee8",
    importpath = "github.com/go-toolsmith/pkgload",
)

go_repository(
    name = "com_github_go_toolsmith_strparse",
    commit = "830b6daa1241",
    importpath = "github.com/go-toolsmith/strparse",
)

go_repository(
    name = "com_github_go_toolsmith_typep",
    commit = "d63dc7650676",
    importpath = "github.com/go-toolsmith/typep",
)

go_repository(
    name = "com_github_gobwas_glob",
    importpath = "github.com/gobwas/glob",
    tag = "v0.2.3",
)

go_repository(
    name = "com_github_gogo_protobuf",
    importpath = "github.com/gogo/protobuf",
    tag = "v1.1.1",
)

go_repository(
    name = "com_github_golang_mock",
    importpath = "github.com/golang/mock",
    tag = "v1.1.1",
)

go_repository(
    name = "com_github_golangci_check",
    commit = "cfe4005ccda2",
    importpath = "github.com/golangci/check",
)

go_repository(
    name = "com_github_golangci_dupl",
    commit = "3e9179ac440a",
    importpath = "github.com/golangci/dupl",
)

go_repository(
    name = "com_github_golangci_errcheck",
    commit = "ef45e06d44b6",
    importpath = "github.com/golangci/errcheck",
)

go_repository(
    name = "com_github_golangci_go_misc",
    commit = "927a3d87b613",
    importpath = "github.com/golangci/go-misc",
)

go_repository(
    name = "com_github_golangci_go_tools",
    commit = "35a9f45a5db0",
    importpath = "github.com/golangci/go-tools",
)

go_repository(
    name = "com_github_golangci_goconst",
    commit = "041c5f2b40f3",
    importpath = "github.com/golangci/goconst",
)

go_repository(
    name = "com_github_golangci_gocyclo",
    commit = "2becd97e67ee",
    importpath = "github.com/golangci/gocyclo",
)

go_repository(
    name = "com_github_golangci_gofmt",
    commit = "0b8337e80d98",
    importpath = "github.com/golangci/gofmt",
)

go_repository(
    name = "com_github_golangci_golangci_lint",
    importpath = "github.com/golangci/golangci-lint",
    tag = "v1.15.0",
)

go_repository(
    name = "com_github_golangci_gosec",
    commit = "66fb7fc33547",
    importpath = "github.com/golangci/gosec",
)

go_repository(
    name = "com_github_golangci_govet",
    commit = "44ddbe260190",
    importpath = "github.com/golangci/govet",
)

go_repository(
    name = "com_github_golangci_ineffassign",
    commit = "2ee8f2867dde",
    importpath = "github.com/golangci/ineffassign",
)

go_repository(
    name = "com_github_golangci_lint_1",
    commit = "4bf9709227d1",
    importpath = "github.com/golangci/lint-1",
)

go_repository(
    name = "com_github_golangci_maligned",
    commit = "b1d89398deca",
    importpath = "github.com/golangci/maligned",
)

go_repository(
    name = "com_github_golangci_misspell",
    commit = "950f5d19e770",
    importpath = "github.com/golangci/misspell",
)

go_repository(
    name = "com_github_golangci_prealloc",
    commit = "215b22d4de21",
    importpath = "github.com/golangci/prealloc",
)

go_repository(
    name = "com_github_golangci_revgrep",
    commit = "d9c87f5ffaf0",
    importpath = "github.com/golangci/revgrep",
)

go_repository(
    name = "com_github_golangci_unconvert",
    commit = "28b1c447d1f4",
    importpath = "github.com/golangci/unconvert",
)

go_repository(
    name = "com_github_google_go_cmp",
    importpath = "github.com/google/go-cmp",
    tag = "v0.2.0",
)

go_repository(
    name = "com_github_hashicorp_hcl",
    commit = "ef8a98b0bbce",
    importpath = "github.com/hashicorp/hcl",
)

go_repository(
    name = "com_github_hpcloud_tail",
    importpath = "github.com/hpcloud/tail",
    tag = "v1.0.0",
)

go_repository(
    name = "com_github_inconshreveable_mousetrap",
    importpath = "github.com/inconshreveable/mousetrap",
    tag = "v1.0.0",
)

go_repository(
    name = "com_github_kisielk_gotool",
    importpath = "github.com/kisielk/gotool",
    tag = "v1.0.0",
)

go_repository(
    name = "com_github_kr_pretty",
    importpath = "github.com/kr/pretty",
    tag = "v0.1.0",
)

go_repository(
    name = "com_github_kr_pty",
    importpath = "github.com/kr/pty",
    tag = "v1.1.1",
)

go_repository(
    name = "com_github_kr_text",
    importpath = "github.com/kr/text",
    tag = "v0.1.0",
)

go_repository(
    name = "com_github_logrusorgru_aurora",
    commit = "a7b3b318ed4e",
    importpath = "github.com/logrusorgru/aurora",
)

go_repository(
    name = "com_github_magiconair_properties",
    importpath = "github.com/magiconair/properties",
    tag = "v1.7.6",
)

go_repository(
    name = "com_github_mattn_go_colorable",
    importpath = "github.com/mattn/go-colorable",
    tag = "v0.0.9",
)

go_repository(
    name = "com_github_mattn_go_isatty",
    importpath = "github.com/mattn/go-isatty",
    tag = "v0.0.3",
)

go_repository(
    name = "com_github_mattn_goveralls",
    importpath = "github.com/mattn/goveralls",
    tag = "v0.0.2",
)

go_repository(
    name = "com_github_mitchellh_go_homedir",
    importpath = "github.com/mitchellh/go-homedir",
    tag = "v1.0.0",
)

go_repository(
    name = "com_github_mitchellh_go_ps",
    commit = "4fdf99ab2936",
    importpath = "github.com/mitchellh/go-ps",
)

go_repository(
    name = "com_github_mitchellh_mapstructure",
    commit = "00c29f56e238",
    importpath = "github.com/mitchellh/mapstructure",
)

go_repository(
    name = "com_github_mozilla_tls_observatory",
    commit = "8791a200eb40",
    importpath = "github.com/mozilla/tls-observatory",
)

go_repository(
    name = "com_github_nbutton23_zxcvbn_go",
    commit = "eafdab6b0663",
    importpath = "github.com/nbutton23/zxcvbn-go",
)

go_repository(
    name = "com_github_onsi_ginkgo",
    importpath = "github.com/onsi/ginkgo",
    tag = "v1.6.0",
)

go_repository(
    name = "com_github_onsi_gomega",
    importpath = "github.com/onsi/gomega",
    tag = "v1.4.2",
)

go_repository(
    name = "com_github_openpeedeep_depguard",
    commit = "a69c782687b2",
    importpath = "github.com/OpenPeeDeeP/depguard",
)

go_repository(
    name = "com_github_pkg_errors",
    importpath = "github.com/pkg/errors",
    tag = "v0.8.0",
)

go_repository(
    name = "com_github_rogpeppe_go_internal",
    importpath = "github.com/rogpeppe/go-internal",
    tag = "v1.1.0",
)

go_repository(
    name = "com_github_ryanuber_go_glob",
    commit = "256dc444b735",
    importpath = "github.com/ryanuber/go-glob",
)

go_repository(
    name = "com_github_shirou_gopsutil",
    commit = "c95755e4bcd7",
    importpath = "github.com/shirou/gopsutil",
)

go_repository(
    name = "com_github_shirou_w32",
    commit = "bb4de0191aa4",
    importpath = "github.com/shirou/w32",
)

go_repository(
    name = "com_github_shurcool_go",
    commit = "9e1955d9fb6e",
    importpath = "github.com/shurcooL/go",
)

go_repository(
    name = "com_github_shurcool_go_goon",
    commit = "37c2f522c041",
    importpath = "github.com/shurcooL/go-goon",
)

go_repository(
    name = "com_github_sirupsen_logrus",
    importpath = "github.com/sirupsen/logrus",
    tag = "v1.0.5",
)

go_repository(
    name = "com_github_spf13_afero",
    importpath = "github.com/spf13/afero",
    tag = "v1.1.0",
)

go_repository(
    name = "com_github_spf13_cast",
    importpath = "github.com/spf13/cast",
    tag = "v1.2.0",
)

go_repository(
    name = "com_github_spf13_cobra",
    importpath = "github.com/spf13/cobra",
    tag = "v0.0.2",
)

go_repository(
    name = "com_github_spf13_jwalterweatherman",
    commit = "7c0cea34c8ec",
    importpath = "github.com/spf13/jwalterweatherman",
)

go_repository(
    name = "com_github_spf13_pflag",
    importpath = "github.com/spf13/pflag",
    tag = "v1.0.1",
)

go_repository(
    name = "com_github_spf13_viper",
    importpath = "github.com/spf13/viper",
    tag = "v1.0.2",
)

go_repository(
    name = "com_github_stackexchange_wmi",
    commit = "5d049714c4a6",
    importpath = "github.com/StackExchange/wmi",
)

go_repository(
    name = "com_sourcegraph_sourcegraph_go_diff",
    importpath = "sourcegraph.com/sourcegraph/go-diff",
    tag = "v0.5.1-0.20190210232911-dee78e514455",
)

go_repository(
    name = "com_sourcegraph_sqs_pbtypes",
    commit = "d3ebe8f20ae4",
    importpath = "sourcegraph.com/sqs/pbtypes",
)

go_repository(
    name = "in_gopkg_airbrake_gobrake_v2",
    importpath = "gopkg.in/airbrake/gobrake.v2",
    tag = "v2.0.9",
)

go_repository(
    name = "in_gopkg_errgo_v2",
    importpath = "gopkg.in/errgo.v2",
    tag = "v2.1.0",
)

go_repository(
    name = "in_gopkg_fsnotify_v1",
    importpath = "gopkg.in/fsnotify.v1",
    tag = "v1.4.7",
)

go_repository(
    name = "in_gopkg_gemnasium_logrus_airbrake_hook_v2",
    importpath = "gopkg.in/gemnasium/logrus-airbrake-hook.v2",
    tag = "v2.1.2",
)

go_repository(
    name = "in_gopkg_tomb_v1",
    commit = "dd632973f1e7",
    importpath = "gopkg.in/tomb.v1",
)

go_repository(
    name = "org_golang_x_crypto",
    commit = "4ec37c66abab",
    importpath = "golang.org/x/crypto",
)

go_repository(
    name = "org_golang_x_net",
    commit = "161cd47e91fd",
    importpath = "golang.org/x/net",
)

go_repository(
    name = "org_golang_x_sync",
    commit = "1d60e4601c6f",
    importpath = "golang.org/x/sync",
)

go_repository(
    name = "org_golang_x_text",
    importpath = "golang.org/x/text",
    tag = "v0.3.0",
)
