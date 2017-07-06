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

// walkSource walks the source tree recursively from pkgPath, adding
// any BUILD files to v.newRules to be formatted.
//
// If AddSourcesRules is enabled in the kazel config, then we additionally add
// package-sources and recursive all-srcs filegroups rules to every BUILD file.
//
// Returns the list of children all-srcs targets that should be added to the
// all-srcs rule of the enclosing package.
func (v *Vendorer) walkSource(pkgPath string) ([]string, error) {
	// clean pkgPath since we access v.newRules directly
	pkgPath = filepath.Clean(pkgPath)
	for _, r := range v.skippedPaths {
		if r.Match([]byte(pkgPath)) {
			return nil, nil
		}
	}
	files, err := ioutil.ReadDir(pkgPath)
	if err != nil {
		return nil, err
	}

	// Find any children packages we need to include in an all-srcs rule.
	var children []string = nil
	for _, f := range files {
		if f.IsDir() {
			c, err := v.walkSource(filepath.Join(pkgPath, f.Name()))
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

	pkgSrcsExpr := &bzl.LiteralExpr{Token: `glob(["**"])`}
	if pkgPath == "." {
		pkgSrcsExpr = &bzl.LiteralExpr{Token: `glob(["**"], exclude=["bazel-*/**", ".git/**"])`}
	}

	v.addRules(pkgPath, []*bzl.Rule{
		newRule(RuleTypeFileGroup,
			func(_ RuleType) string { return pkgSrcsTarget },
			map[string]bzl.Expr{
				"srcs":       pkgSrcsExpr,
				"visibility": asExpr([]string{"//visibility:private"}),
			}),
		newRule(RuleTypeFileGroup,
			func(_ RuleType) string { return allSrcsTarget },
			map[string]bzl.Expr{
				"srcs": asExpr(append(children, fmt.Sprintf(":%s", pkgSrcsTarget))),
			}),
	})
	return []string{fmt.Sprintf("//%s:%s", pkgPath, allSrcsTarget)}, nil
}
