# Verification scripts

Collection of scripts that verifies that a project meets requirements set for kubernetes related projects. The scripts are to be invoked depending on the needs via CI tooling, such as Travis CI. See main Readme file on how to integrate the repo-infra in your project. 

The scripts are currently being migrated from the main kubernetes repository. If your project requires additional set of verifications, consider creating an issue/PR on repo-infra to avoid code duplication across multiple projects. 

If repo-infra is integrated at the root of your project as git submodule at path: `/repo-infra`,
then scripts can be invoked as `repo-infra/verify/verify-*.sh`

## Verify boilerplate

Verifies that the boilerplate for various formats (go files, Makefile, etc.) is included in each file: `verify-boilerplate.sh`. 

## Verify go source code 

Runs a set of scripts on the go source code excluding vendored files: `verify-go-src.sh`

Run with `-v` to see the output

Checks include:

1. gofmt
2. gometalinter
3. govet