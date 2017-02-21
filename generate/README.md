Generation Scripts
==================

This directory contains the minimum required to run the
hack/update-codegen.sh and hack/update-codecgen.sh scripts.

The requisite go2idl sources were pulled from the commits listed below,
and were modified to change the import paths to reference the repo-infra
repository, and remove k8s.io/kubernetes-specific parts when possible.

The requisitie scripts and makefiles are striped down versions of their
counterparts in k8s.io/kubernetes.  Note that the scripts *must* be run
from the root directory of the repository in order for the corresponding
Makefiles to function properly.

You also need to define a file in the root of your repository called
`repo-infra-config.sh`.  It is used by both the scripts and the makefiles
to configure themselves, and must be both shell-syntax and Makefile-syntax
compatible.  It should look roughly like this:

```sh
REPO_AVAILABLE_GROUP_VERSIONS=custom_metrics/v1alpha1
REPO_GO_PACKAGE=k8s.io/metrics
```

go2idl Sources
--------------

**Base Commit**:
k8s.io/kubernetes@2be53cf0f82c1518aaab3e1ad3382450defd0a67

### Modifications ###

- [not-yet-upstreamed] Allow overriding the resource name
- [non-yet-upstreamed] Support Read-Only APIs
- [cherry-pick] kubernetes/kubernetes#41486
