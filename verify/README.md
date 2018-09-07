# Verification scripts

Collection of scripts that verifies that a project meets requirements set for kubernetes related projects. The scripts are to be invoked depending on the needs via CI tooling, such as Travis CI. See main Readme file on how to integrate the repo-infra in your project. 

The scripts are currently being migrated from the main kubernetes repository. If your project requires additional set of verifications, consider creating an issue/PR on repo-infra to avoid code duplication across multiple projects. 

If repo-infra is integrated at the root of your project as git submodule at path: `/repo-infra`,
then scripts can be invoked as `repo-infra/verify/verify-*.sh`

travis.yaml example: 

```
dist: trusty

os:
- linux

language: go

go:
- 1.8

before_install:
- go get -u github.com/alecthomas/gometalinter

install:
- gometalinter --install

script:
- repo-infra/verify/verify-go-src.sh -v
- repo-infra/verify/verify-boilerplate.sh
# OR with vendoring 
# - vendor/github.com/kubernetes/repo-infra/verify-go-src.sh --rootdir=$(pwd) -v
```

## Verify & Ensure boilerplate

- `verify-boilerplate.sh`:  
   Verifies that the boilerplate for various formats (go files, Makefile, etc.)
   is included in each file.
- `ensure-boilerplate.sh`:  
   Ensure that various formats (see above) have the boilerplate included.

The scripts assume the root of the repo to be two levels up of the directory
the scripts are in.

If this is not the case, you can configure the root of the reop by either
setting `REPO_ROOT` or by calling the scripts with `--root-dir=<root>`.

You can put a config file into the root of your repo named `boilerplate.json`.
The config can look something like this:
```json
{
  "dirs_to_skip" : [
    "vendor",
    "tools/contrib"
  ],
  "not_generated_files_to_skip" : [
    "some/file",
    "some/other/file.something"
  ]
}
```
Currently supported settings are
- `dirs_to_skip`  
  A list of directories which is excluded when checking or adding the headers
- `not_generated_files_to_skip`  
  A list of all the files contain 'DO NOT EDIT', but are not generated

All other settings will be ignored.

### Tests

To run the test, cd into the boilerplate directory and run `python -m unittest boilerplate_test`.

## Verify go source code 

Runs a set of scripts on the go source code excluding vendored files: `verify-go-src.sh`. Expects `gometalinter` tooling installed (see travis file above)

With git submodule from your repo root: `repo-infra/verify/verify-go-src.sh -v`

With vendoring: `vendor/repo-infra/verify/verify-go-src.sh -v --rootdir $(pwd)`

Checks include:

1. gofmt
2. gometalinter
3. govet
