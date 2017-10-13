/*
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"fmt"
	"io/ioutil"
	"path/filepath"

	bzl "github.com/bazelbuild/buildifier/core"
)

const (
	pkgSrcsTarget = "package-srcs"
	allSrcsTarget = "all-srcs"
)

var allVisitors []sourceVisitor = []sourceVisitor{allSrcsVisitor}

func (v *Vendorer) walkSource(pkgPath string) error {
	for _, visitor := range allVisitors {
		_, err := v.walkSourceHelper(pkgPath, visitor)
		if err != nil {
			return err
		}
	}
	return nil
}

// A sourceVisitor takes a package path and a list of child targets and returns
// a list of bazel rules to add and a string describing the target that should
// be used by a parent rule.
type sourceVisitor func(pkgPath string, childTargets []string) (rules []*bzl.Rule, selfTarget string)

// This visitor generates the package-srcs and all-srcs targets.
func allSrcsVisitor(pkgPath string, childTargets []string) (rules []*bzl.Rule, selfTarget string) {
	pkgSrcsExpr := &bzl.LiteralExpr{Token: `glob(["**"])`}
	if pkgPath == "." {
		pkgSrcsExpr = &bzl.LiteralExpr{Token: `glob(["**"], exclude=["bazel-*/**", ".git/**"])`}
	}

	rules = []*bzl.Rule{
		newRule(RuleTypeFileGroup,
			func(_ ruleType) string { return pkgSrcsTarget },
			map[string]bzl.Expr{
				"srcs":       pkgSrcsExpr,
				"visibility": asExpr([]string{"//visibility:private"}),
			}),
		newRule(RuleTypeFileGroup,
			func(_ ruleType) string { return allSrcsTarget },
			map[string]bzl.Expr{
				"srcs": asExpr(append(childTargets, fmt.Sprintf(":%s", pkgSrcsTarget))),
				// TODO: should this be more restricted?
				"visibility": asExpr([]string{"//visibility:public"}),
			}),
	}

	selfTarget = fmt.Sprintf("//%s:%s", pkgPath, allSrcsTarget)

	return
}

// walkSourceHelper walks the source tree recursively from pkgPath, adding
// any BUILD files to v.newRules to be formatted.
//
// If AddSourcesRules is enabled in the kazel config, then we additionally add
// package-sources and recursive all-srcs filegroups rules to every BUILD file.
//
// Returns the list of children all-srcs targets that should be added to the
// all-srcs rule of the enclosing package.
func (v *Vendorer) walkSourceHelper(pkgPath string, visitor sourceVisitor) ([]string, error) {
	// clean pkgPath since we access v.newRules directly
	pkgPath = filepath.Clean(pkgPath)
	for _, r := range v.skippedPaths {
		if r.MatchString(pkgPath) {
			return nil, nil
		}
	}
	files, err := ioutil.ReadDir(pkgPath)
	if err != nil {
		return nil, err
	}

	// Find any children packages we need to include in an all-srcs rule.
	var children []string
	for _, f := range files {
		if f.IsDir() {
			c, err := v.walkSourceHelper(filepath.Join(pkgPath, f.Name()), visitor)
			if err != nil {
				return nil, err
			}
			children = append(children, c...)
		}
	}

	// This path is a package either if we've added rules or if a BUILD file already exists.
	_, hasRules := v.newRules[pkgPath]
	isPkg := hasRules
	if !isPkg {
		isPkg, _ = findBuildFile(pkgPath)
	}

	if !isPkg {
		// This directory isn't a package (doesn't contain a BUILD file),
		// but there might be subdirectories that are packages,
		// so pass that up to our parent.
		return children, nil
	}

	// Enforce formatting the BUILD file, even if we're not adding srcs rules
	if !hasRules {
		v.addRules(pkgPath, nil)
	}

	if !v.cfg.AddSourcesRules {
		return nil, nil
	}

	rules, selfTarget := visitor(pkgPath, children)
	v.addRules(pkgPath, rules)

	return []string{selfTarget}, nil
}
