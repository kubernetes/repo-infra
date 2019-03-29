module k8s.io/repo-infra

go 1.12

replace github.com/golang/lint => golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3

require (
	github.com/BurntSushi/toml v0.3.1 // indirect
	github.com/bazelbuild/bazel-gazelle v0.0.0-20181220163313-cdeedbd62467
	github.com/bazelbuild/buildtools v0.0.0-20180226164855-80c7f0d45d7e
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/golang/protobuf v1.3.1
	github.com/kr/pretty v0.1.0 // indirect
	github.com/pelletier/go-toml v1.1.0 // indirect
	golang.org/x/build v0.0.0-20171220025321-125f04e1fc4b
	golang.org/x/tools v0.0.0-20190125232054-379209517ffe // indirect
	gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127 // indirect
	k8s.io/klog v0.0.0-20181102134211-b9b56d5dfc92
)
