# Copyright 2019 The Kubernetes Authors.
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

load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_repositories():
    go_repository(
        name = "cc_mvdan_interfacer",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "mvdan.cc/interfacer",
        sum = "h1:WX1yoOaKQfddO/mLzdV4wptyWgoH/6hwLs7QHTixo0I=",
        version = "v0.0.0-20180901003855-c20040233aed",
    )
    go_repository(
        name = "cc_mvdan_lint",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "mvdan.cc/lint",
        sum = "h1:DxJ5nJdkhDlLok9K6qO+5290kphDJbHOQO1DFFFTeBo=",
        version = "v0.0.0-20170908181259-adc824a0674b",
    )
    go_repository(
        name = "cc_mvdan_unparam",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "mvdan.cc/unparam",
        sum = "h1:duVSyluuJA+u0BnkcLR01smoLrGgDTfWt5c8ODYG8fU=",
        version = "v0.0.0-20190209190245-fbb59629db34",
    )
    go_repository(
        name = "com_github_bazelbuild_bazel_gazelle",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/bazelbuild/bazel-gazelle",
        sum = "h1:UAAr18IbmGSK9Jw0dqmU63eMc4BqPgFeHKvktOzmx+o=",
        version = "v0.0.0-20181220163313-cdeedbd62467",
    )
    go_repository(
        name = "com_github_bazelbuild_buildtools",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/bazelbuild/buildtools",
        sum = "h1:VuTBHPJNCQ88Okm9ld5SyLCvU50soWJYQYjQFdcDxew=",
        version = "v0.0.0-20180226164855-80c7f0d45d7e",
    )
    go_repository(
        name = "com_github_burntsushi_toml",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/BurntSushi/toml",
        sum = "h1:WXkYYl6Yr3qBf1K79EBnL4mak0OimBfB0XUf9Vl28OQ=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_davecgh_go_spew",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/davecgh/go-spew",
        sum = "h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_fatih_color",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/fatih/color",
        sum = "h1:66qjqZk8kalYAvDRtM1AdAJQI0tj4Wrue3Eq3B3pmFU=",
        version = "v1.6.0",
    )
    go_repository(
        name = "com_github_fsnotify_fsnotify",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/fsnotify/fsnotify",
        sum = "h1:IXs+QLmnXW2CcXuY+8Mzv/fWEsPGWxqefPtCP5CnV9I=",
        version = "v1.4.7",
    )
    go_repository(
        name = "com_github_go_critic_go_critic",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-critic/go-critic",
        sum = "h1:djv/qAomOVj8voCHt0M0OYwR/4vfDq1zNKSPKjJCexs=",
        version = "v0.3.5-0.20190526074819-1df300866540",
    )
    go_repository(
        name = "com_github_go_lintpack_lintpack",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-lintpack/lintpack",
        sum = "h1:DI5mA3+eKdWeJ40nU4d6Wc26qmdG8RCi/btYq0TuRN0=",
        version = "v0.5.2",
    )
    go_repository(
        name = "com_github_go_ole_go_ole",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-ole/go-ole",
        sum = "h1:2lOsA72HgjxAuMlKpFiCbHTvu44PIVkZ5hqm3RSdI/E=",
        version = "v1.2.1",
    )
    go_repository(
        name = "com_github_go_toolsmith_astcast",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astcast",
        sum = "h1:JojxlmI6STnFVG9yOImLeGREv8W2ocNUM+iOhR6jE7g=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_astcopy",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astcopy",
        sum = "h1:OMgl1b1MEpjFQ1m5ztEO06rz5CUd3oBv9RF7+DyvdG8=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_astequal",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astequal",
        sum = "h1:4zxD8j3JRFNyLN46lodQuqz3xdKSrur7U/sr0SDS/gQ=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_astfmt",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astfmt",
        sum = "h1:A0vDDXt+vsvLEdbMFJAUBI/uTbRw1ffOPnxsILnFL6k=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_astinfo",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astinfo",
        sum = "h1:wP6mXeB2V/d1P1K7bZ5vDUO3YqEzcvOREOxZPEu3gVI=",
        version = "v0.0.0-20180906194353-9809ff7efb21",
    )
    go_repository(
        name = "com_github_go_toolsmith_astp",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/astp",
        sum = "h1:alXE75TXgcmupDsMK1fRAy0YUzLzqPVvBKoyWV+KPXg=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_pkgload",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/pkgload",
        sum = "h1:4DFWWMXVfbcN5So1sBNW9+yeiMqLFGl1wFLTL5R0Tgg=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_strparse",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/strparse",
        sum = "h1:Vcw78DnpCAKlM20kSbAyO4mPfJn/lyYA4BJUDxe2Jb4=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_go_toolsmith_typep",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/go-toolsmith/typep",
        sum = "h1:zKymWyA1TRYvqYrYDrfEMZULyrhcnGY3x7LDKU2XQaA=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_gobwas_glob",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/gobwas/glob",
        sum = "h1:A4xDbljILXROh+kObIiy5kIaPYD8e96x1tgBhUI5J+Y=",
        version = "v0.2.3",
    )
    go_repository(
        name = "com_github_gogo_protobuf",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/gogo/protobuf",
        sum = "h1:72R+M5VuhED/KujmZVcIquuo8mBgX4oVda//DQb3PXo=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_golang_mock",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/mock",
        sum = "h1:HzcpUG60pfl43n9d2qbdi/3l1uKpAmxlfWEPWtV/QxM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_golang_protobuf",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golang/protobuf",
        sum = "h1:P3YflyNX/ehuJFLhxviNdFxQPkGK5cDcApsge1SqnvM=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_golangci_check",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/check",
        sum = "h1:23T5iq8rbUYlhpt5DB4XJkc6BU31uODLD1o1gKvZmD0=",
        version = "v0.0.0-20180506172741-cfe4005ccda2",
    )
    go_repository(
        name = "com_github_golangci_dupl",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/dupl",
        sum = "h1:w8hkcTqaFpzKqonE9uMCefW1WDie15eSP/4MssdenaM=",
        version = "v0.0.0-20180902072040-3e9179ac440a",
    )
    go_repository(
        name = "com_github_golangci_errcheck",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/errcheck",
        sum = "h1:YYWNAGTKWhKpcLLt7aSj/odlKrSrelQwlovBpDuf19w=",
        version = "v0.0.0-20181223084120-ef45e06d44b6",
    )
    go_repository(
        name = "com_github_golangci_go_misc",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/go-misc",
        sum = "h1:9kfjN3AdxcbsZBf8NjltjWihK2QfBBBZuv91cMFfDHw=",
        version = "v0.0.0-20180628070357-927a3d87b613",
    )
    go_repository(
        name = "com_github_golangci_go_tools",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/go-tools",
        sum = "h1:/7detzz5stiXWPzkTlPTzkBEIIE4WGpppBJYjKqBiPI=",
        version = "v0.0.0-20190318055746-e32c54105b7c",
    )
    go_repository(
        name = "com_github_golangci_goconst",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/goconst",
        sum = "h1:pe9JHs3cHHDQgOFXJJdYkK6fLz2PWyYtP4hthoCMvs8=",
        version = "v0.0.0-20180610141641-041c5f2b40f3",
    )
    go_repository(
        name = "com_github_golangci_gocyclo",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/gocyclo",
        sum = "h1:J2XAy40+7yz70uaOiMbNnluTg7gyQhtGqLQncQh+4J8=",
        version = "v0.0.0-20180528134321-2becd97e67ee",
    )
    go_repository(
        name = "com_github_golangci_gofmt",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/gofmt",
        sum = "h1:0OkFarm1Zy2CjCiDKfK9XHgmc2wbDlRMD2hD8anAJHU=",
        version = "v0.0.0-20181222123516-0b8337e80d98",
    )
    go_repository(
        name = "com_github_golangci_golangci_lint",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/golangci-lint",
        sum = "h1:XmQgfcLofSG/6AsQuQqmLizB+3GggD+o6ObBG9L+VMM=",
        version = "v1.18.0",
    )
    go_repository(
        name = "com_github_golangci_gosec",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/gosec",
        sum = "h1:fUdgm/BdKvwOHxg5AhNbkNRp2mSy8sxTXyBVs/laQHo=",
        version = "v0.0.0-20190211064107-66fb7fc33547",
    )
    go_repository(
        name = "com_github_golangci_ineffassign",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/ineffassign",
        sum = "h1:gLLhTLMk2/SutryVJ6D4VZCU3CUqr8YloG7FPIBWFpI=",
        version = "v0.0.0-20190609212857-42439a7714cc",
    )
    go_repository(
        name = "com_github_golangci_lint_1",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/lint-1",
        sum = "h1:En/tZdwhAn0JNwLuXzP3k2RVtMqMmOEK7Yu/g3tmtJE=",
        version = "v0.0.0-20190420132249-ee948d087217",
    )
    go_repository(
        name = "com_github_golangci_maligned",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/maligned",
        sum = "h1:kNY3/svz5T29MYHubXix4aDDuE3RWHkPvopM/EDv/MA=",
        version = "v0.0.0-20180506175553-b1d89398deca",
    )
    go_repository(
        name = "com_github_golangci_misspell",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/misspell",
        sum = "h1:EL/O5HGrF7Jaq0yNhBLucz9hTuRzj2LdwGBOaENgxIk=",
        version = "v0.0.0-20180809174111-950f5d19e770",
    )
    go_repository(
        name = "com_github_golangci_prealloc",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/prealloc",
        sum = "h1:leSNB7iYzLYSSx3J/s5sVf4Drkc68W2wm4Ixh/mr0us=",
        version = "v0.0.0-20180630174525-215b22d4de21",
    )
    go_repository(
        name = "com_github_golangci_revgrep",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/revgrep",
        sum = "h1:HVfrLniijszjS1aiNg8JbBMO2+E1WIQ+j/gL4SQqGPg=",
        version = "v0.0.0-20180526074752-d9c87f5ffaf0",
    )
    go_repository(
        name = "com_github_golangci_unconvert",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/golangci/unconvert",
        sum = "h1:zwtduBRr5SSWhqsYNgcuWO2kFlpdOZbP0+yRjmvPGys=",
        version = "v0.0.0-20180507085042-28b1c447d1f4",
    )
    go_repository(
        name = "com_github_google_go_cmp",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/google/go-cmp",
        sum = "h1:+dTQ8DZQJz0Mb/HjFlkptS1FeQ4cWSnN941F8aEG4SQ=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_gostaticanalysis_analysisutil",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/gostaticanalysis/analysisutil",
        sum = "h1:JVnpOZS+qxli+rgVl98ILOXVNbW+kb5wcxeGx8ShUIw=",
        version = "v0.0.0-20190318220348-4088753ea4d3",
    )
    go_repository(
        name = "com_github_hashicorp_hcl",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/hashicorp/hcl",
        sum = "h1:xdsDDbiBDQTKASoGEZ+pEmF1OnWuu8AQ9I8iNbHNeno=",
        version = "v0.0.0-20180404174102-ef8a98b0bbce",
    )
    go_repository(
        name = "com_github_hpcloud_tail",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/hpcloud/tail",
        sum = "h1:nfCOvKYfkgYP8hkirhJocXT2+zOD8yUNjXaWfTlyFKI=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_inconshreveable_mousetrap",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/inconshreveable/mousetrap",
        sum = "h1:Z8tu5sraLXCXIcARxBp/8cbvlwVa7Z1NHg9XEKhtSvM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_kisielk_gotool",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/kisielk/gotool",
        sum = "h1:AV2c/EiW3KqPNT9ZKl07ehoAGi4C5/01Cfbblndcapg=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_klauspost_compress",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/klauspost/compress",
        sum = "h1:8VMb5+0wMgdBykOV96DwNwKFQ+WTI4pzYURP99CcB9E=",
        version = "v1.4.1",
    )
    go_repository(
        name = "com_github_klauspost_cpuid",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/klauspost/cpuid",
        sum = "h1:NMpwD2G9JSFOE1/TJjGSo5zG7Yb2bTe7eq1jH+irmeE=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_kr_pretty",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/pretty",
        sum = "h1:L/CwN0zerZDmRFUapSPitk6f+Q3+0za1rQkzVuMiMFI=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_kr_pty",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/pty",
        sum = "h1:VkoXIwSboBpnk99O/KFauAEILuNHv5DVFKZMBN/gUgw=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_kr_text",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/kr/text",
        sum = "h1:45sCR5RtlFHMR4UwH9sdQ5TC8v0qDQCHnXt+kaKSTVE=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_logrusorgru_aurora",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/logrusorgru/aurora",
        sum = "h1:9MlwzLdW7QSDrhDjFlsEYmxpFyIoXmYRon3dt0io31k=",
        version = "v0.0.0-20181002194514-a7b3b318ed4e",
    )
    go_repository(
        name = "com_github_magiconair_properties",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/magiconair/properties",
        sum = "h1:U+1DqNen04MdEPgFiIwdOUiqZ8qPa37xgogX/sd3+54=",
        version = "v1.7.6",
    )
    go_repository(
        name = "com_github_mattn_go_colorable",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/go-colorable",
        sum = "h1:UVL0vNpWh04HeJXV0KLcaT7r06gOH2l4OW6ddYRUIY4=",
        version = "v0.0.9",
    )
    go_repository(
        name = "com_github_mattn_go_isatty",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/go-isatty",
        sum = "h1:ns/ykhmWi7G9O+8a448SecJU3nSMBXJfqQkl0upE1jI=",
        version = "v0.0.3",
    )
    go_repository(
        name = "com_github_mattn_goveralls",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mattn/goveralls",
        sum = "h1:7eJB6EqsPhRVxvwEXGnqdO2sJI0PTsrWoTMXEk9/OQc=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_mitchellh_go_homedir",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/go-homedir",
        sum = "h1:vKb8ShqSby24Yrqr/yDYkuFz8d0WUjys40rvnGC8aR0=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_mitchellh_go_ps",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/go-ps",
        sum = "h1:kw1v0NlnN+GZcU8Ma8CLF2Zzgjfx95gs3/GN3vYAPpo=",
        version = "v0.0.0-20170309133038-4fdf99ab2936",
    )
    go_repository(
        name = "com_github_mitchellh_mapstructure",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mitchellh/mapstructure",
        sum = "h1:+MZW2uvHgN8kYvksEN3f7eFL2wpzk0GxmlFsMybWc7E=",
        version = "v0.0.0-20180220230111-00c29f56e238",
    )
    go_repository(
        name = "com_github_mozilla_tls_observatory",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/mozilla/tls-observatory",
        sum = "h1:Q0XH6Ql1+Z6YbUKyWyI0sD8/9yH0U8x86yA8LuWMJwY=",
        version = "v0.0.0-20180409132520-8791a200eb40",
    )
    go_repository(
        name = "com_github_nbutton23_zxcvbn_go",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/nbutton23/zxcvbn-go",
        sum = "h1:Ri1EhipkbhWsffPJ3IPlrb4SkTOPa2PfRXp3jchBczw=",
        version = "v0.0.0-20171102151520-eafdab6b0663",
    )
    go_repository(
        name = "com_github_onsi_ginkgo",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/onsi/ginkgo",
        sum = "h1:Ix8l273rp3QzYgXSR+c8d1fTG7UPgYkOSELPhiY/YGw=",
        version = "v1.6.0",
    )
    go_repository(
        name = "com_github_onsi_gomega",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/onsi/gomega",
        sum = "h1:3mYCb7aPxS/RU7TI1y4rkEn1oKmPRjNJLNEXgw7MH2I=",
        version = "v1.4.2",
    )
    go_repository(
        name = "com_github_openpeedeep_depguard",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/OpenPeeDeeP/depguard",
        sum = "h1:k9QF73nrHT3nPLz3lu6G5s+3Hi8Je36ODr1F5gjAXXM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_pelletier_go_toml",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/pelletier/go-toml",
        sum = "h1:cmiOvKzEunMsAxyhXSzpL5Q1CRKpVv0KQsnAIcSEVYM=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_pkg_errors",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/pkg/errors",
        sum = "h1:iURUrRGxPUNPdy5/HRSm+Yj6okJ6UtLINN0Q9M4+h3I=",
        version = "v0.8.1",
    )
    go_repository(
        name = "com_github_pmezard_go_difflib",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/pmezard/go-difflib",
        sum = "h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_quasilyte_go_consistent",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/quasilyte/go-consistent",
        sum = "h1:JoUA0uz9U0FVFq5p4LjEq4C0VgQ0El320s3Ms0V4eww=",
        version = "v0.0.0-20190521200055-c6f3937de18c",
    )
    go_repository(
        name = "com_github_rogpeppe_go_internal",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/rogpeppe/go-internal",
        sum = "h1:g0fH8RicVgNl+zVZDCDfbdWxAWoAEJyI7I3TZYXFiig=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_ryanuber_go_glob",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/ryanuber/go-glob",
        sum = "h1:7YvPJVmEeFHR1Tj9sZEYsmarJEQfMVYpd/Vyy/A8dqE=",
        version = "v0.0.0-20170128012129-256dc444b735",
    )
    go_repository(
        name = "com_github_shirou_gopsutil",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/shirou/gopsutil",
        sum = "h1:80VN+vGkqM773Br/uNNTSheo3KatTgV8IpjIKjvVLng=",
        version = "v0.0.0-20180427012116-c95755e4bcd7",
    )
    go_repository(
        name = "com_github_shirou_w32",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/shirou/w32",
        sum = "h1:udFKJ0aHUL60LboW/A+DfgoHVedieIzIXE8uylPue0U=",
        version = "v0.0.0-20160930032740-bb4de0191aa4",
    )
    go_repository(
        name = "com_github_shurcool_go",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/go",
        sum = "h1:MZM7FHLqUHYI0Y/mQAt3d2aYa0SiNms/hFqC9qJYolM=",
        version = "v0.0.0-20180423040247-9e1955d9fb6e",
    )
    go_repository(
        name = "com_github_shurcool_go_goon",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/shurcooL/go-goon",
        sum = "h1:llrF3Fs4018ePo4+G/HV/uQUqEI1HMDjCeOf2V6puPc=",
        version = "v0.0.0-20170922171312-37c2f522c041",
    )
    go_repository(
        name = "com_github_sirupsen_logrus",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/sirupsen/logrus",
        sum = "h1:8c8b5uO0zS4X6RPl/sd1ENwSkIc0/H2PaHxE3udaE8I=",
        version = "v1.0.5",
    )
    go_repository(
        name = "com_github_sourcegraph_go_diff",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/sourcegraph/go-diff",
        sum = "h1:gO6i5zugwzo1RVTvgvfwCOSVegNuvnNi6bAD1QCmkHs=",
        version = "v0.5.1",
    )
    go_repository(
        name = "com_github_spf13_afero",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/afero",
        sum = "h1:bopulORc2JeYaxfHLvJa5NzxviA9PoWhpiiJkru7Ji4=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_spf13_cast",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/cast",
        sum = "h1:HHl1DSRbEQN2i8tJmtS6ViPyHx35+p51amrdsiTCrkg=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_spf13_cobra",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/cobra",
        sum = "h1:NfkwRbgViGoyjBKsLI0QMDcuMnhM+SBg3T0cGfpvKDE=",
        version = "v0.0.2",
    )
    go_repository(
        name = "com_github_spf13_jwalterweatherman",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/jwalterweatherman",
        sum = "h1:2ZXvIUGghLpdTVHR1UfvfrzoVlZaE/yOWC5LueIHZig=",
        version = "v0.0.0-20180109140146-7c0cea34c8ec",
    )
    go_repository(
        name = "com_github_spf13_pflag",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/pflag",
        sum = "h1:aCvUg6QPl3ibpQUxyLkrEkCHtPqYJL4x9AuhqVqFis4=",
        version = "v1.0.1",
    )
    go_repository(
        name = "com_github_spf13_viper",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/spf13/viper",
        sum = "h1:Ncr3ZIuJn322w2k1qmzXDnkLAdQMlJqBa9kfAH+irso=",
        version = "v1.0.2",
    )
    go_repository(
        name = "com_github_stackexchange_wmi",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/StackExchange/wmi",
        sum = "h1:fLjPD/aNc3UIOA6tDi6QXUemppXK3P9BI7mr2hd6gx8=",
        version = "v0.0.0-20180116203802-5d049714c4a6",
    )
    go_repository(
        name = "com_github_stretchr_testify",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/stretchr/testify",
        sum = "h1:bSDNvY7ZPG5RlJ8otE/7V6gMiyenm9RtJ7IUVIAoJ1w=",
        version = "v1.2.2",
    )
    go_repository(
        name = "com_github_timakin_bodyclose",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/timakin/bodyclose",
        sum = "h1:AmoEvWAO3nDx1MEcMzPh+GzOOIA5Znpv6++c7bePPY0=",
        version = "v0.0.0-20190721030226-87058b9bfcec",
    )
    go_repository(
        name = "com_github_ultraware_funlen",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/ultraware/funlen",
        sum = "h1:UeC9tpM4wNWzUJfan8z9sFE4QCzjjzlCZmuJN+aOkH0=",
        version = "v0.0.1",
    )
    go_repository(
        name = "com_github_valyala_bytebufferpool",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/valyala/bytebufferpool",
        sum = "h1:GqA5TC/0021Y/b9FG4Oi9Mr3q7XYx6KllzawFIhcdPw=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_valyala_fasthttp",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/valyala/fasthttp",
        sum = "h1:dzZJf2IuMiclVjdw0kkT+f9u4YdrapbNyGAN47E/qnk=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_valyala_quicktemplate",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/valyala/quicktemplate",
        sum = "h1:C58y/wN0FMTi2PR0n3onltemfFabany53j7M6SDDB8k=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_valyala_tcplisten",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "github.com/valyala/tcplisten",
        sum = "h1:0R4NLDRDZX6JcmhJgXi5E4b8Wg84ihbmUKp/GvSPEzc=",
        version = "v0.0.0-20161114210144-ceec8f93295a",
    )
    go_repository(
        name = "com_sourcegraph_sqs_pbtypes",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "sourcegraph.com/sqs/pbtypes",
        sum = "h1:JPJh2pk3+X4lXAkZIk2RuE/7/FoK9maXw+TNPJhVS/c=",
        version = "v0.0.0-20180604144634-d3ebe8f20ae4",
    )
    go_repository(
        name = "in_gopkg_airbrake_gobrake_v2",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/airbrake/gobrake.v2",
        sum = "h1:7z2uVWwn7oVeeugY1DtlPAy5H+KYgB1KeKTnqjNatLo=",
        version = "v2.0.9",
    )
    go_repository(
        name = "in_gopkg_check_v1",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/check.v1",
        sum = "h1:qIbj1fsPNlZgppZ+VLlY7N33q108Sa+fhmuc+sWQYwY=",
        version = "v1.0.0-20180628173108-788fd7840127",
    )
    go_repository(
        name = "in_gopkg_errgo_v2",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/errgo.v2",
        sum = "h1:0vLT13EuvQ0hNvakwLuFZ/jYrLp5F3kcWHXdRggjCE8=",
        version = "v2.1.0",
    )
    go_repository(
        name = "in_gopkg_fsnotify_v1",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/fsnotify.v1",
        sum = "h1:xOHLXZwVvI9hhs+cLKq5+I5onOuwQLhQwiu63xxlHs4=",
        version = "v1.4.7",
    )
    go_repository(
        name = "in_gopkg_gemnasium_logrus_airbrake_hook_v2",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/gemnasium/logrus-airbrake-hook.v2",
        sum = "h1:OAj3g0cR6Dx/R07QgQe8wkA9RNjB2u4i700xBkIT4e0=",
        version = "v2.1.2",
    )
    go_repository(
        name = "in_gopkg_tomb_v1",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/tomb.v1",
        sum = "h1:uRGJdciOHaEIrze2W8Q3AKkepLTh2hOroT7a+7czfdQ=",
        version = "v1.0.0-20141024135613-dd632973f1e7",
    )
    go_repository(
        name = "in_gopkg_yaml_v2",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "gopkg.in/yaml.v2",
        sum = "h1:mUhvW9EsL+naU5Q3cakzfE91YhliOondGd6ZrsDBHQE=",
        version = "v2.2.1",
    )
    go_repository(
        name = "io_k8s_klog",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "k8s.io/klog",
        sum = "h1:PgoMI/L1Nu5Vmvgm+vGheLuxKST8h6FMOqggyAFtHPc=",
        version = "v0.0.0-20181102134211-b9b56d5dfc92",
    )
    go_repository(
        name = "org_golang_x_build",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/build",
        sum = "h1:Hgyq56/B1VbKi6tNXTJq3eo63zJbRzQr4uBZqiciilA=",
        version = "v0.0.0-20171220025321-125f04e1fc4b",
    )
    go_repository(
        name = "org_golang_x_crypto",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/crypto",
        sum = "h1:YX8ljsm6wXlHZO+aRz9Exqr0evNhKRNe5K/gi+zKh4U=",
        version = "v0.0.0-20190313024323-a1f597ede03a",
    )
    go_repository(
        name = "org_golang_x_net",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/net",
        sum = "h1:R/3boaszxrf1GEUWTVDzSKVwLmSJpwZ1yqXm8j0v2QI=",
        version = "v0.0.0-20190620200207-3b0461eec859",
    )
    go_repository(
        name = "org_golang_x_sync",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/sync",
        sum = "h1:8gQV6CLnAEikrhgkHFbMAEhagSSnXWGV915qUMm9mrU=",
        version = "v0.0.0-20190423024810-112230192c58",
    )
    go_repository(
        name = "org_golang_x_sys",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/sys",
        sum = "h1:pczuHS43Cp2ktBEEmLwScxgjWsBSzdaQiKzUyf3DTTc=",
        version = "v0.0.0-20190312061237-fead79001313",
    )
    go_repository(
        name = "org_golang_x_text",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/text",
        sum = "h1:g61tztE5qeGQ89tm6NTjjM9VPIm088od1l6aSorWRWg=",
        version = "v0.3.0",
    )
    go_repository(
        name = "org_golang_x_tools_random_extra_stuff",  # Why???
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/tools",
        sum = "h1:bw9doJza/SFBEweII/rHQh338oozWyiFsBRHtrflcws=",
        version = "v0.0.0-20190920225731-5eefd052ad72",
    )
    go_repository(
        name = "org_golang_x_xerrors",
        build_file_generation = "on",
        build_file_proto_mode = "disable",
        importpath = "golang.org/x/xerrors",
        sum = "h1:9zdDQZ7Thm29KFXgAX/+yaf3eVbP7djjWp/dXAppNCc=",
        version = "v0.0.0-20190717185122-a985d3407aa7",
    )
