package main

import (
	"encoding/json"
	"io/ioutil"
)

type Cfg struct {
	GoPrefix string
	// evaluated recursively, defaults to ["."]
	SrcDirs []string
	// regexps that match packages to skip
	SkippedPaths []string
	// whether to add "pkg-srcs" and "all-srcs" filegroups
	// note that this operates on the entire tree (not just SrcsDirs) but skips anything matching SkippedPaths
	AddSourcesRules bool
	// whether to have multiple build files in vendor/ or just one.
	VendorMultipleBuildFiles bool
	// whether to manage kubernetes' pkg/generated/openapi.
	K8sOpenAPIGen bool
}

func ReadCfg(cfgPath string) (*Cfg, error) {
	b, err := ioutil.ReadFile(cfgPath)
	if err != nil {
		return nil, err
	}
	var cfg Cfg
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil, err
	}
	defaultCfg(&cfg)
	return &cfg, nil
}

func defaultCfg(c *Cfg) {
	if len(c.SrcDirs) == 0 {
		c.SrcDirs = []string{"."}
	}
}
