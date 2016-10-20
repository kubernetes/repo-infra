package main

import (
	"bytes"
	"flag"
	"fmt"
	"go/build"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"

	bzl "github.com/bazelbuild/buildifier/core"
	"github.com/golang/glog"
)

var kubeRoot = os.Getenv("KUBE_ROOT")
var dryRun = flag.Bool("dry-run", false, "run in dry mode")

func main() {
	flag.Parse()
	flag.Set("alsologtostderr", "true")
	v := Venderor{
		ctx: &build.Default,
	}
	if len(flag.Args()) == 1 {
		v.updateSinglePkg(flag.Args()[0])
	} else {
		v.walkVendor()
		if err := v.walkRepo(); err != nil {
			glog.Fatalf("err: %v", err)
		}
	}
}

type Venderor struct {
	ctx *build.Context
}

func writeHeaders(file *bzl.File) {
	pkgRule := bzl.Rule{
		&bzl.CallExpr{
			X: &bzl.LiteralExpr{Token: "package"},
		},
	}
	pkgRule.SetAttr("default_visibility", asExpr([]string{"//visibility:public"}))

	file.Stmt = append(file.Stmt,
		[]bzl.Expr{
			pkgRule.Call,
			&bzl.CallExpr{
				X:    &bzl.LiteralExpr{Token: "licenses"},
				List: []bzl.Expr{asExpr([]string{"notice"})},
			},
			&bzl.CallExpr{
				X: &bzl.LiteralExpr{Token: "load"},
				List: asExpr([]string{
					"@io_bazel_rules_go//go:def.bzl",
					"go_binary",
					"go_library",
					"go_test",
					"cgo_library",
				}).(*bzl.ListExpr).List,
			},
		}...,
	)
}

func writeRules(file *bzl.File, rules []*bzl.Rule) {
	for _, rule := range rules {
		file.Stmt = append(file.Stmt, rule.Call)
	}
}

func (v *Venderor) resolve(ipath string) Label {
	if strings.HasPrefix(ipath, "k8s.io/kubernetes") {
		return Label{
			pkg: strings.TrimPrefix(ipath, "k8s.io/kubernetes/"),
			tag: "go_default_library",
		}
	}
	return Label{
		pkg: "vendor",
		tag: ipath,
	}
}

func (v *Venderor) walk(root string, f func(path, ipath string, pkg *build.Package) error) error {
	return filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		ipath, err := filepath.Rel(root, path)
		if err != nil {
			return err
		}
		if !info.IsDir() {
			return nil
		}
		pkg, err := v.ctx.ImportDir(filepath.Join(kubeRoot, path), build.ImportComment)
		if err != nil {
			if _, ok := err.(*build.NoGoError); err != nil && ok {
				return nil
			} else {
				return err
			}
		}

		return f(path, ipath, pkg)
	})
}

func (v *Venderor) walkRepo() error {
	for _, root := range []string{
		"./pkg",
		"./cmd",
		"./third_party",
		"./plugin",
		"./test",
		"./federation",
	} {
		if err := v.walk(root, v.updatePkg); err != nil {
			return err
		}
	}
	return nil
}

func (v *Venderor) updateSinglePkg(path string) error {
	pkg, err := v.ctx.ImportDir("./"+path, build.ImportComment)
	if err != nil {
		if _, ok := err.(*build.NoGoError); err != nil && ok {
			return nil
		} else {
			return err
		}
	}
	return v.updatePkg(path, "", pkg)
}

func (v *Venderor) updatePkg(path, _ string, pkg *build.Package) error {
	var rules []*bzl.Rule

	var attrs Attrs = make(Attrs)
	srcs := asExpr(merge(pkg.GoFiles, pkg.SFiles)).(*bzl.ListExpr)

	deps := v.extractDeps(pkg.Imports)

	if len(srcs.List) == 0 {
		return nil
	}
	attrs.Set("srcs", srcs)

	if len(deps.List) > 0 {
		attrs.Set("deps", deps)
	}

	if pkg.IsCommand() {
		rules = append(rules, newRule("go_binary", filepath.Base(pkg.Dir), attrs))
	} else {
		rules = append(rules, newRule("go_library", "go_default_library", attrs))
		if len(pkg.TestGoFiles) != 0 {
			rules = append(rules, newRule("go_test", "go_default_test", map[string]bzl.Expr{
				"srcs":    asExpr(pkg.TestGoFiles),
				"deps":    v.extractDeps(pkg.TestImports),
				"library": asExpr("go_default_library"),
			}))
		}
	}

	if len(pkg.XTestGoFiles) != 0 {
		rules = append(rules, newRule("go_test", "go_default_xtest", map[string]bzl.Expr{
			"srcs": asExpr(pkg.XTestGoFiles),
			"deps": v.extractDeps(pkg.XTestImports),
		}))
	}

	wrote, err := ReconcileRules(filepath.Join(path, "BUILD"), rules)
	if err != nil {
		return err
	}
	if wrote {
		fmt.Fprintf(os.Stderr, "wrote BUILD for %q\n", pkg.Dir)
	}
	return nil
}

func (v *Venderor) walkVendor() {
	var rules []*bzl.Rule
	if err := v.walk("./vendor", func(path, ipath string, pkg *build.Package) error {
		var attrs Attrs = make(Attrs)

		srcs := asExpr(
			apply(
				merge(pkg.GoFiles, pkg.SFiles),
				mapper(func(s string) string {
					return strings.TrimPrefix(filepath.Join(path, s), "vendor/")
				}),
			),
		).(*bzl.ListExpr)

		cgoSrcs := asExpr(
			apply(
				merge(pkg.CgoFiles, pkg.CFiles, pkg.CXXFiles, pkg.HFiles),
				mapper(func(s string) string {
					return strings.TrimPrefix(filepath.Join(path, s), "vendor/")
				}),
			),
		).(*bzl.ListExpr)

		deps := v.extractDeps(pkg.Imports)
		attrs.Set("srcs", srcs)

		if len(deps.List) > 0 {
			attrs.Set("deps", deps)
		}

		if pkg.IsCommand() {
			rules = append(rules, newRule("go_binary", v.resolve(ipath).tag, attrs))
		} else {
			if len(cgoSrcs.List) != 0 {
				cgoPname := v.resolve(ipath).tag + "_cgo"
				cgoDeps := v.extractDeps(pkg.TestImports)
				cgoRule := newRule("cgo_library", cgoPname, map[string]bzl.Expr{
					"srcs":      cgoSrcs,
					"clinkopts": asExpr([]string{"-ldl", "-lz", "-lm", "-lpthread", "-ldl"}),
				})
				rules = append(rules, cgoRule)
				if len(cgoDeps.List) != 0 {
					cgoRule.SetAttr("deps", cgoDeps)
				}
				attrs["library"] = asExpr(cgoPname)
			}
			rules = append(rules, newRule("go_library", v.resolve(ipath).tag, attrs))
		}
		return nil
	}); err != nil {
		glog.Fatalf("err: %v", err)
	}
	if _, err := ReconcileRules("./vendor/BUILD", rules); err != nil {
		glog.Fatalf("err: %v", err)
	}
}

func (v *Venderor) extractDeps(deps []string) *bzl.ListExpr {
	return asExpr(
		apply(
			merge(deps),
			filterer(func(s string) bool {
				pkg, err := v.ctx.Import(s, kubeRoot, build.ImportComment)
				if err != nil {
					return false
				}
				if pkg.Goroot {
					return false
				}
				return true
			}),
			mapper(func(s string) string {
				return v.resolve(s).String()
			}),
		),
	).(*bzl.ListExpr)
}

type Attrs map[string]bzl.Expr

func (a Attrs) Set(name string, expr bzl.Expr) {
	a[name] = expr
}

type Label struct {
	pkg, tag string
}

func (l Label) String() string {
	return fmt.Sprintf("//%v:%v", l.pkg, l.tag)
}

func asExpr(e interface{}) bzl.Expr {
	rv := reflect.ValueOf(e)
	switch rv.Kind() {
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64,
		reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
		return &bzl.LiteralExpr{Token: fmt.Sprintf("%d", e)}
	case reflect.Float32, reflect.Float64:
		return &bzl.LiteralExpr{Token: fmt.Sprintf("%f", e)}
	case reflect.String:
		return &bzl.StringExpr{Value: e.(string)}
	case reflect.Slice, reflect.Array:
		var list []bzl.Expr
		for i := 0; i < rv.Len(); i++ {
			list = append(list, asExpr(rv.Index(i).Interface()))
		}
		return &bzl.ListExpr{List: list}
	default:
		glog.Fatalf("Uh oh")
		return nil
	}
}

type Sed func(s []string) []string

func mapString(in []string, f func(string) string) []string {
	var out []string
	for _, s := range in {
		out = append(out, f(s))
	}
	return out
}

func mapper(f func(string) string) Sed {
	return func(in []string) []string {
		return mapString(in, f)
	}
}

func filterString(in []string, f func(string) bool) []string {
	var out []string
	for _, s := range in {
		if f(s) {
			out = append(out, s)
		}
	}
	return out
}

func filterer(f func(string) bool) Sed {
	return func(in []string) []string {
		return filterString(in, f)
	}
}

func apply(stream []string, seds ...Sed) []string {
	for _, sed := range seds {
		stream = sed(stream)
	}
	return stream
}

func merge(streams ...[]string) []string {
	var out []string
	for _, stream := range streams {
		out = append(out, stream...)
	}
	return out
}

func newRule(kind, name string, attrs map[string]bzl.Expr) *bzl.Rule {
	rule := &bzl.Rule{
		Call: &bzl.CallExpr{
			X: &bzl.LiteralExpr{Token: kind},
		},
	}
	rule.SetAttr("name", asExpr(name))
	for k, v := range attrs {
		rule.SetAttr(k, v)
	}
	rule.SetAttr("tags", asExpr([]string{"automanaged"}))
	return rule
}

func ReconcileRules(path string, rules []*bzl.Rule) (bool, error) {
	info, err := os.Stat(path)
	if err != nil && os.IsNotExist(err) {
		f := &bzl.File{}
		writeHeaders(f)
		writeRules(f, rules)
		return writeFile(path, f, false)
	} else if err != nil {
		return false, err
	}
	if info.IsDir() {
		return false, fmt.Errorf("%q cannot be a directory", path)
	}
	b, err := ioutil.ReadFile(path)
	if err != nil {
		return false, err
	}
	f, err := bzl.Parse(path, b)
	if err != nil {
		return false, err
	}
	oldRules := make(map[string]*bzl.Rule)
	for _, r := range f.Rules("") {
		oldRules[r.Name()] = r
	}
	for _, r := range rules {
		o, ok := oldRules[r.Name()]
		if !ok {
			f.Stmt = append(f.Stmt, r.Call)
			continue
		}
		if !RuleIsManaged(o) {
			continue
		}
		reconcileAttr := func(o, n *bzl.Rule, name string) {
			if e := n.Attr(name); e != nil {
				o.SetAttr(name, e)
			} else {
				o.DelAttr(name)
			}
		}
		reconcileAttr(o, r, "srcs")
		reconcileAttr(o, r, "deps")
		reconcileAttr(o, r, "library")
		delete(oldRules, r.Name())
	}
	for _, r := range oldRules {
		if !RuleIsManaged(r) {
			continue
		}
		f.DelRules(r.Kind(), r.Name())
	}
	return writeFile(path, f, true)
}

func RuleIsManaged(r *bzl.Rule) bool {
	var automanaged bool
	for _, tag := range r.AttrStrings("tags") {
		if tag == "automanaged" {
			automanaged = true
			break
		}
	}
	return automanaged
}

func writeFile(path string, f *bzl.File, exists bool) (bool, error) {
	var info bzl.RewriteInfo
	bzl.Rewrite(f, &info)
	out := bzl.Format(f)
	if exists {
		orig, err := ioutil.ReadFile(path)
		if err != nil {
			return false, err
		}
		if bytes.Compare(out, orig) == 0 {
			return false, nil
		}
	}
	if *dryRun {
		return true, nil
	}
	return true, ioutil.WriteFile(path, out, 0644)

}
