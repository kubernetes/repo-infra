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
	"regexp"
	"runtime"
	"sort"
	"strings"

	"github.com/mikedanese/gazel/third_party/go/path/filepath"

	bzl "github.com/bazelbuild/buildifier/core"
	"github.com/golang/glog"
)

const vendorPath = "vendor/"

func main() {
	var (
		root    = flag.String("root", "", "root of go source")
		dryRun  = flag.Bool("dry-run", false, "run in dry mode")
		cfgPath = flag.String("cfg-path", ".gazelcfg.json", "path to gazel config (relative paths interpreted relative to -repo.")
	)
	flag.Parse()
	flag.Set("alsologtostderr", "true")
	if *root == "" {
		glog.Fatalf("-root argument is required")
	}
	v, err := NewVendorer(*root, *cfgPath, *dryRun)
	if err != nil {
		glog.Fatalf("unable to build venderor: %v", err)
	}

	if len(flag.Args()) == 1 {
		v.updateSinglePkg(flag.Args()[0])
	} else {
		if err := v.walkVendor(); err != nil {
			glog.Fatalf("err walking vendor: %v", err)
		}
		if err := v.walkRepo(); err != nil {
			glog.Fatalf("err walking repo: %v", err)
		}
	}
}

type Vendorer struct {
	ctx          *build.Context
	icache       map[icacheKey]icacheVal
	skippedPaths []*regexp.Regexp
	dryRun       bool
	root         string
	cfg          *Cfg
}

func NewVendorer(root, cfgPath string, dryRun bool) (*Vendorer, error) {
	cfg, err := ReadCfg(root, cfgPath)
	if err != nil {
		return nil, err
	}

	v := Vendorer{
		ctx:    context(),
		dryRun: dryRun,
		root:   root,
		icache: map[icacheKey]icacheVal{},
		cfg:    cfg,
	}

	for _, sp := range cfg.SkippedPaths {
		r, err := regexp.Compile(sp)
		if err != nil {
			return nil, err
		}
		v.skippedPaths = append(v.skippedPaths, r)
	}
	for _, builtinSkip := range []string{
		"^\\.git",
		"^bazel-*",
	} {
		v.skippedPaths = append(v.skippedPaths, regexp.MustCompile(builtinSkip))
	}

	return &v, nil

}

type icacheKey struct {
	path, srcDir string
}

type icacheVal struct {
	pkg *build.Package
	err error
}

func (v *Vendorer) importPkg(path string, srcDir string) (*build.Package, error) {
	k := icacheKey{path: path, srcDir: srcDir}
	if val, ok := v.icache[k]; ok {
		return val.pkg, val.err
	}

	// cache miss
	pkg, err := v.ctx.Import(path, srcDir, build.ImportComment)
	v.icache[k] = icacheVal{pkg: pkg, err: err}
	return pkg, err
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

func (v *Vendorer) resolve(ipath string) Label {
	if strings.HasPrefix(ipath, v.cfg.GoPrefix) {
		return Label{
			pkg: strings.TrimPrefix(ipath, v.cfg.GoPrefix+"/"),
			tag: "go_default_library",
		}
	}
	return Label{
		pkg: "vendor",
		tag: ipath,
	}
}

func (v *Vendorer) walk(root string, f func(path, ipath string, pkg *build.Package) error) error {
	skipVendor := true
	if root == vendorPath {
		skipVendor = false
	}
	return sfilepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			return nil
		}
		if skipVendor && strings.HasPrefix(path, vendorPath) {
			return filepath.SkipDir
		}
		for _, r := range v.skippedPaths {
			if r.Match([]byte(path)) {
				return filepath.SkipDir
			}
		}
		ipath, err := filepath.Rel(root, path)
		if err != nil {
			return err
		}
		pkg, err := v.importPkg(".", filepath.Join(v.root, path))
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

func (v *Vendorer) walkRepo() error {
	for _, root := range v.cfg.SrcDirs {
		if err := v.walk(root, v.updatePkg); err != nil {
			return err
		}
	}
	return nil
}

func (v *Vendorer) updateSinglePkg(path string) error {
	pkg, err := v.importPkg(".", "./"+path)
	if err != nil {
		if _, ok := err.(*build.NoGoError); err != nil && ok {
			return nil
		} else {
			return err
		}
	}
	return v.updatePkg(path, "", pkg)
}

type RuleType int

const (
	RuleTypeGoBinary RuleType = iota
	RuleTypeGoLibrary
	RuleTypeGoTest
	RuleTypeGoXTest
	RuleTypeCGoGenrule
)

func (rt RuleType) RuleKind() string {
	switch rt {
	case RuleTypeGoBinary:
		return "go_binary"
	case RuleTypeGoLibrary:
		return "go_library"
	case RuleTypeGoTest:
		return "go_test"
	case RuleTypeGoXTest:
		return "go_test"
	case RuleTypeCGoGenrule:
		return "cgo_genrule"
	}
	panic("unreachable")
}

type NamerFunc func(RuleType) string

func (v *Vendorer) updatePkg(path, _ string, pkg *build.Package) error {

	srcs := asExpr(merge(pkg.GoFiles, pkg.SFiles)).(*bzl.ListExpr)
	cgoSrcs := asExpr(merge(pkg.CgoFiles, pkg.CFiles, pkg.CXXFiles, pkg.HFiles)).(*bzl.ListExpr)

	deps := v.extractDeps(pkg.Imports)

	rules := v.emit(srcs, cgoSrcs, deps, pkg, func(rt RuleType) string {
		switch rt {
		case RuleTypeGoBinary:
			return filepath.Base(pkg.Dir)
		case RuleTypeGoLibrary:
			return "go_default_library"
		case RuleTypeGoTest:
			return "go_default_test"
		case RuleTypeGoXTest:
			return "go_default_xtest"
		case RuleTypeCGoGenrule:
			return "cgo_codegen"
		}
		panic("unreachable")
	})

	wrote, err := ReconcileRules(filepath.Join(path, "BUILD"), rules, v.dryRun)
	if err != nil {
		return err
	}
	if wrote {
		fmt.Fprintf(os.Stderr, "wrote BUILD for %q\n", pkg.Dir)
	}
	return nil
}

func (v *Vendorer) emit(srcs, cgoSrcs, deps *bzl.ListExpr, pkg *build.Package, namer NamerFunc) []*bzl.Rule {
	var attrs Attrs = make(Attrs)
	var rules []*bzl.Rule

	if len(srcs.List) >= 0 {
		attrs.Set("srcs", srcs)
	} else if len(cgoSrcs.List) == 0 {
		return nil
	}

	if len(deps.List) > 0 {
		attrs.Set("deps", deps)
	}
	if pkg.IsCommand() {
		rules = append(rules, newRule(RuleTypeGoBinary, namer, attrs))
	} else {
		addGoDefaultLibrary := len(cgoSrcs.List) > 0 || len(srcs.List) > 0
		if len(cgoSrcs.List) != 0 {
			cgoRule := newRule(RuleTypeCGoGenrule, namer, map[string]bzl.Expr{
				"srcs":      cgoSrcs,
				"clinkopts": asExpr([]string{"-lz", "-lm", "-lpthread", "-ldl"}),
			})
			rules = append(rules, cgoRule)
			attrs["library"] = asExpr(namer(RuleTypeCGoGenrule))
		}
		if len(pkg.TestGoFiles) != 0 {
			xtestRule := newRule(RuleTypeGoTest, namer, map[string]bzl.Expr{
				"srcs": asExpr(pkg.TestGoFiles),
				"deps": v.extractDeps(pkg.TestImports),
			})
			if addGoDefaultLibrary {
				xtestRule.SetAttr("library", asExpr(namer(RuleTypeGoLibrary)))
			}
			rules = append(rules, xtestRule)
		}
		if addGoDefaultLibrary {
			rules = append(rules, newRule(RuleTypeGoLibrary, namer, attrs))
		}
	}

	if len(pkg.XTestGoFiles) != 0 {
		rules = append(rules, newRule(RuleTypeGoXTest, namer, map[string]bzl.Expr{
			"srcs": asExpr(pkg.XTestGoFiles),
			"deps": v.extractDeps(pkg.XTestImports),
		}))
	}
	return rules
}

func (v *Vendorer) walkVendor() error {
	var rules []*bzl.Rule
	if err := v.walk(vendorPath, func(path, ipath string, pkg *build.Package) error {
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

		tagBase := v.resolve(ipath).tag

		rules = append(rules, v.emit(srcs, cgoSrcs, deps, pkg, func(rt RuleType) string {
			switch rt {
			case RuleTypeGoBinary:
				return tagBase + "_bin"
			case RuleTypeGoLibrary:
				return tagBase
			case RuleTypeGoTest:
				return tagBase + "_test"
			case RuleTypeGoXTest:
				return tagBase + "_xtest"
			case RuleTypeCGoGenrule:
				return tagBase + "_cgo"
			}
			panic("unreachable")
		})...)

		return nil
	}); err != nil {
		return err
	}
	wrote, err := ReconcileRules("./vendor/BUILD", rules, v.dryRun)
	if err != nil {
		return err
	}
	if wrote {
		fmt.Fprintf(os.Stderr, "wrote BUILD for ./vendor/\n")
	}
	return nil
}

func (v *Vendorer) extractDeps(deps []string) *bzl.ListExpr {
	return asExpr(
		apply(
			merge(deps),
			filterer(func(s string) bool {
				pkg, err := v.importPkg(s, v.root)
				if err != nil {
					if strings.Contains(err.Error(), `cannot find package "C"`) ||
						// added in go1.7
						strings.Contains(err.Error(), `cannot find package "context"`) ||
						strings.Contains(err.Error(), `cannot find package "net/http/httptrace"`) {
						return false
					}
					fmt.Fprintf(os.Stderr, "extract err: %v\n", err)
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

func newRule(rt RuleType, namer NamerFunc, attrs map[string]bzl.Expr) *bzl.Rule {
	rule := &bzl.Rule{
		Call: &bzl.CallExpr{
			X: &bzl.LiteralExpr{Token: rt.RuleKind()},
		},
	}
	rule.SetAttr("name", asExpr(namer(rt)))
	for k, v := range attrs {
		rule.SetAttr(k, v)
	}
	rule.SetAttr("tags", asExpr([]string{"automanaged"}))
	return rule
}

func ReconcileRules(path string, rules []*bzl.Rule, dryRun bool) (bool, error) {
	info, err := os.Stat(path)
	if err != nil && os.IsNotExist(err) {
		f := &bzl.File{}
		writeHeaders(f)
		reconcileLoad(f, rules)
		writeRules(f, rules)
		return writeFile(path, f, false, dryRun)
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

	reconcileLoad(f, rules)

	for _, r := range oldRules {
		if !RuleIsManaged(r) {
			continue
		}
		f.DelRules(r.Kind(), r.Name())
	}
	return writeFile(path, f, true, dryRun)
}

func reconcileLoad(f *bzl.File, rules []*bzl.Rule) {
	usedRuleKindsMap := map[string]bool{}
	for _, r := range rules {
		usedRuleKindsMap[r.Kind()] = true
	}

	usedRuleKindsList := []string{}
	for k, _ := range usedRuleKindsMap {
		usedRuleKindsList = append(usedRuleKindsList, k)
	}
	sort.Strings(usedRuleKindsList)

	for _, r := range f.Rules("load") {
		const goRulesLabel = "@io_bazel_rules_go//go:def.bzl"
		args := bzl.Strings(&bzl.ListExpr{List: r.Call.List})
		if len(args) == 0 {
			continue
		}
		if args[0] != goRulesLabel {
			continue
		}
		r.Call.List = asExpr(append(
			[]string{goRulesLabel}, usedRuleKindsList...,
		)).(*bzl.ListExpr).List
		break
	}
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

func writeFile(path string, f *bzl.File, exists, dryRun bool) (bool, error) {
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
	if dryRun {
		return true, nil
	}
	return true, ioutil.WriteFile(path, out, 0644)
}

func context() *build.Context {
	return &build.Context{
		GOARCH:      "amd64",
		GOOS:        "linux",
		GOROOT:      build.Default.GOROOT,
		GOPATH:      build.Default.GOPATH,
		ReleaseTags: []string{"go1.1", "go1.2", "go1.3", "go1.4", "go1.5", "go1.6", "go1.7"},
		Compiler:    runtime.Compiler,
		CgoEnabled:  true,
	}
}

func walk(root string, walkFn filepath.WalkFunc) error {
	return nil
}
