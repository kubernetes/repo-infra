module k8s.io/repo-infra

go 1.12

replace github.com/golang/lint => golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3

require (
	github.com/bazelbuild/bazel-gazelle v0.0.0-20181220163313-cdeedbd62467
	github.com/bazelbuild/buildtools v0.0.0-20180226164855-80c7f0d45d7e
	github.com/golang/protobuf v1.3.1
	github.com/pelletier/go-toml v1.1.0 // indirect
	golang.org/x/build v0.0.0-20171220025321-125f04e1fc4b
	golang.org/x/tools v0.0.0-20180324185418-77106db15f68 // indirect
	k8s.io/klog v0.0.0-20181102134211-b9b56d5dfc92
)
