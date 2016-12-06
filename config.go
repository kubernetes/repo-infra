package main

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"
)

type Cfg struct {
	GoPrefix string
	// evaluated recursively, defaults to ["."]
	SrcDirs []string
	// regexps that match packages to skip
	SkippedPaths []string
}

func ReadCfg(root, cfgPath string) (*Cfg, error) {
	if !filepath.IsAbs(cfgPath) {
		cfgPath = filepath.Join(root, cfgPath)
	}
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
