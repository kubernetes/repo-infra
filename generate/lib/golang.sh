#!/bin/bash

# Copyright 2014 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The golang package that we are building.
readonly REPO_GO_PACKAGE="${REPO_GO_PACKAGE:?no go package set}"
readonly REPO_GOPATH="${REPO_OUTPUT}/go"

# TODO: warn if these are empty
readonly REPO_TARGETS="${REPO_TARGETS:-}"
readonly REPO_PLATFORMS="${REPO_PLATFORMS:-linux/amd64}"
readonly REPO_STATIC_LIBRARIES="${REPO_STATIC_LIBRARIES:-}"

# Gigabytes desired for parallel platform builds. 11 is fairly
# arbitrary, but is a reasonable splitting point for 2015
# laptops-versus-not.
readonly REPO_PARALLEL_BUILD_MEMORY=11

readonly REPO_BINARIES=("${REPO_TARGETS[@]##*/}")

# TODO: what do we do with this?

repo::golang::is_statically_linked_library() {
  local e
  for e in "${REPO_STATIC_LIBRARIES[@]}"; do [[ "$1" == *"/$e" ]] && return 0; done;
  # Allow individual overrides--e.g., so that you can get a static build of
  # kubectl for inclusion in a container.
  if [ -n "${REPO_STATIC_OVERRIDES:+x}" ]; then
    for e in "${REPO_STATIC_OVERRIDES[@]}"; do [[ "$1" == *"/$e" ]] && return 0; done;
  fi
  return 1;
}

# repo::binaries_from_targets take a list of build targets and return the
# full go package to be built
repo::golang::binaries_from_targets() {
  local target
  for target; do
    # If the target starts with what looks like a domain name, assume it has a
    # fully-qualified package name rather than one that needs the Kubernetes
    # package prepended.
    if [[ "${target}" =~ ^([[:alnum:]]+".")+[[:alnum:]]+"/" ]]; then
      echo "${target}"
    else
      echo "${REPO_GO_PACKAGE}/${target}"
    fi
  done
}

# Asks golang what it thinks the host platform is. The go tool chain does some
# slightly different things when the target platform matches the host platform.
repo::golang::host_platform() {
  echo "$(go env GOHOSTOS)/$(go env GOHOSTARCH)"
}

repo::golang::current_platform() {
  local os="${GOOS-}"
  if [[ -z $os ]]; then
    os=$(go env GOHOSTOS)
  fi

  local arch="${GOARCH-}"
  if [[ -z $arch ]]; then
    arch=$(go env GOHOSTARCH)
  fi

  echo "$os/$arch"
}

# Takes the the platform name ($1) and sets the appropriate golang env variables
# for that platform.
repo::golang::set_platform_envs() {
  [[ -n ${1-} ]] || {
    repo::log::error_exit "!!! Internal error. No platform set in repo::golang::set_platform_envs"
  }

  export GOOS=${platform%/*}
  export GOARCH=${platform##*/}

  # Do not set CC when building natively on a platform, only if cross-compiling from linux/amd64
  if [[ $(repo::golang::host_platform) == "linux/amd64" ]]; then

    # Dynamic CGO linking for other server architectures than linux/amd64 goes here
    # If you want to include support for more server platforms than these, add arch-specific gcc names here
    case "${platform}" in
      "linux/arm")
        export CGO_ENABLED=1
        export CC=arm-linux-gnueabihf-gcc
        # Use a special edge version of golang since the stable golang version used for everything else doesn't work
        export GOROOT=${REPO_EDGE_GOROOT}
        ;;
      "linux/arm64")
        export CGO_ENABLED=1
        export CC=aarch64-linux-gnu-gcc
        ;;
      "linux/ppc64le")
        export CGO_ENABLED=1
        export CC=powerpc64le-linux-gnu-gcc
        # Use a special edge version of golang since the stable golang version used for everything else doesn't work
        export GOROOT=${REPO_EDGE_GOROOT}
        ;;
      "linux/s390x")
        export CGO_ENABLED=1
        export CC=s390x-linux-gnu-gcc
        ;;
    esac
  fi
}

repo::golang::unset_platform_envs() {
  unset GOOS
  unset GOARCH
  unset GOROOT
  unset CGO_ENABLED
  unset CC
}

# Create the GOPATH tree under $REPO_OUTPUT
repo::golang::create_gopath_tree() {
  local go_pkg_dir="${REPO_GOPATH}/src/${REPO_GO_PACKAGE}"
  local go_pkg_basedir=$(dirname "${go_pkg_dir}")

  mkdir -p "${go_pkg_basedir}"

  # TODO: This symlink should be relative.
  if [[ ! -e "${go_pkg_dir}" || "$(readlink ${go_pkg_dir})" != "${REPO_ROOT}" ]]; then
    ln -snf "${REPO_ROOT}" "${go_pkg_dir}"
  fi

  cat >"${REPO_GOPATH}/BUILD" <<EOF
# This dummy BUILD file prevents Bazel from trying to descend through the
# infinite loop created by the symlink at
# ${go_pkg_dir}
EOF
}

# Ensure the godep tool exists and is a viable version.
repo::golang::verify_godep_version() {
  local -a godep_version_string
  local godep_version
  local godep_min_version="63"

  if ! which godep &>/dev/null; then
    repo::log::usage_from_stdin <<EOF
Can't find 'godep' in PATH, please fix and retry.
See https://github.com/kubernetes/kubernetes/blob/master/docs/devel/development.md#godep-and-dependency-management for installation instructions.
EOF
    return 2
  fi

  godep_version_string=($(godep version))
  godep_version=${godep_version_string[1]/v/}
  if ((godep_version<$godep_min_version)); then
    repo::log::usage_from_stdin <<EOF
Detected godep version: ${godep_version_string[*]}.
Kubernetes requires godep v$godep_min_version or greater.
Please update:
go get -u github.com/tools/godep
EOF
    return 2
  fi
}

# Ensure the go tool exists and is a viable version.
repo::golang::verify_go_version() {
  if [[ -z "$(which go)" ]]; then
    repo::log::usage_from_stdin <<EOF
Can't find 'go' in PATH, please fix and retry.
See http://golang.org/doc/install for installation instructions.
EOF
    return 2
  fi

  local go_version
  go_version=($(go version))
  if [[ "${go_version[2]}" < "go1.6" && "${go_version[2]}" != "devel" ]]; then
    repo::log::usage_from_stdin <<EOF
Detected go version: ${go_version[*]}.
Kubernetes requires go version 1.6 or greater.
Please install Go version 1.6 or later.
EOF
    return 2
  fi
}

# repo::golang::setup_env will check that the `go` commands is available in
# ${PATH}. It will also check that the Go version is good enough for the
# Kubernetes build.
#
# Inputs:
#   REPO_EXTRA_GOPATH - If set, this is included in created GOPATH
#
# Outputs:
#   env-var GOPATH points to our local output dir
#   env-var GOBIN is unset (we want binaries in a predictable place)
#   env-var GO15VENDOREXPERIMENT=1
#   current directory is within GOPATH
repo::golang::setup_env() {
  repo::golang::verify_go_version

  repo::golang::create_gopath_tree

  export GOPATH=${REPO_GOPATH}

  # Append REPO_EXTRA_GOPATH to the GOPATH if it is defined.
  if [[ -n ${REPO_EXTRA_GOPATH:-} ]]; then
    GOPATH="${GOPATH}:${REPO_EXTRA_GOPATH}"
  fi

  # Change directories so that we are within the GOPATH.  Some tools get really
  # upset if this is not true.  We use a whole fake GOPATH here to collect the
  # resultant binaries.  Go will not let us use GOBIN with `go install` and
  # cross-compiling, and `go install -o <file>` only works for a single pkg.
  local subdir
  subdir=$(repo::realpath . | sed "s|$REPO_ROOT||")
  cd "${REPO_GOPATH}/src/${REPO_GO_PACKAGE}/${subdir}"

  # Set GOROOT so binaries that parse code can work properly.
  export GOROOT=$(go env GOROOT)

  # Unset GOBIN in case it already exists in the current session.
  unset GOBIN

  # This seems to matter to some tools (godep, ugorji, ginkgo...)
  export GO15VENDOREXPERIMENT=1
}

# This will take binaries from $GOPATH/bin and copy them to the appropriate
# place in ${REPO_OUTPUT_BINDIR}
#
# Ideally this wouldn't be necessary and we could just set GOBIN to
# REPO_OUTPUT_BINDIR but that won't work in the face of cross compilation.  'go
# install' will place binaries that match the host platform directly in $GOBIN
# while placing cross compiled binaries into `platform_arch` subdirs.  This
# complicates pretty much everything else we do around packaging and such.
repo::golang::place_bins() {
  local host_platform
  host_platform=$(repo::golang::host_platform)

  V=2 repo::log::status "Placing binaries"

  local platform
  for platform in "${REPO_PLATFORMS[@]}"; do
    # The substitution on platform_src below will replace all slashes with
    # underscores.  It'll transform darwin/amd64 -> darwin_amd64.
    local platform_src="/${platform//\//_}"
    if [[ $platform == $host_platform ]]; then
      platform_src=""
      rm -f "${THIS_PLATFORM_BIN}"
      ln -s "${REPO_OUTPUT_BINPATH}/${platform}" "${THIS_PLATFORM_BIN}"
    fi

    local full_binpath_src="${REPO_GOPATH}/bin${platform_src}"
    if [[ -d "${full_binpath_src}" ]]; then
      mkdir -p "${REPO_OUTPUT_BINPATH}/${platform}"
      find "${full_binpath_src}" -maxdepth 1 -type f -exec \
        rsync -pc {} "${REPO_OUTPUT_BINPATH}/${platform}" \;
    fi
  done
}

repo::golang::fallback_if_stdlib_not_installable() {
  local go_root_dir=$(go env GOROOT);
  local go_host_os=$(go env GOHOSTOS);
  local go_host_arch=$(go env GOHOSTARCH);
  local cgo_pkg_dir=${go_root_dir}/pkg/${go_host_os}_${go_host_arch}_cgo;

  if [ -e ${cgo_pkg_dir} ]; then
    return 0;
  fi

  if [ -w ${go_root_dir}/pkg ]; then
    return 0;
  fi

  repo::log::status "+++ Warning: stdlib pkg with cgo flag not found.";
  repo::log::status "+++ Warning: stdlib pkg cannot be rebuilt since ${go_root_dir}/pkg is not writable by `whoami`";
  repo::log::status "+++ Warning: Make ${go_root_dir}/pkg writable for `whoami` for a one-time stdlib install, Or"
  repo::log::status "+++ Warning: Rebuild stdlib using the command 'CGO_ENABLED=0 go install -a -installsuffix cgo std'";
  repo::log::status "+++ Falling back to go build, which is slower";

  use_go_build=true
}

# Try and replicate the native binary placement of go install without
# calling go install.
repo::golang::output_filename_for_binary() {
  local binary=$1
  local platform=$2
  local output_path="${REPO_GOPATH}/bin"
  if [[ $platform != $host_platform ]]; then
    output_path="${output_path}/${platform//\//_}"
  fi
  local bin=$(basename "${binary}")
  if [[ ${GOOS} == "windows" ]]; then
    bin="${bin}.exe"
  fi
  echo "${output_path}/${bin}"
}

repo::golang::build_binaries_for_platform() {
  local platform=$1
  local use_go_build=${2-}

  local -a statics=()
  local -a nonstatics=()
  local -a tests=()

  # Temporary workaround while we have two GOROOT's (which we'll get rid of as soon as we upgrade to go1.8 for amd64 as well)
  local GO=go
  if [[ "${GOROOT}" == "${REPO_EDGE_GOROOT:-}" ]]; then
    GO="${REPO_EDGE_GOROOT}/bin/go"
  fi

  V=2 repo::log::info "Env for ${platform}: GOOS=${GOOS-} GOARCH=${GOARCH-} GOROOT=${GOROOT-} CGO_ENABLED=${CGO_ENABLED-} CC=${CC-} GO=${GO}"

  for binary in "${binaries[@]}"; do

    if [[ "${binary}" =~ ".test"$ ]]; then
      tests+=($binary)
    elif repo::golang::is_statically_linked_library "${binary}"; then
      statics+=($binary)
    else
      nonstatics+=($binary)
    fi
  done

  if [[ "${#statics[@]}" != 0 ]]; then
      repo::golang::fallback_if_stdlib_not_installable;
  fi

  if [[ -n ${use_go_build:-} ]]; then
    repo::log::progress "    "
    for binary in "${statics[@]:+${statics[@]}}"; do
      local outfile=$(repo::golang::output_filename_for_binary "${binary}" "${platform}")
      CGO_ENABLED=0 "${GO}" build -o "${outfile}" \
        "${goflags[@]:+${goflags[@]}}" \
        -gcflags "${gogcflags}" \
        -ldflags "${goldflags}" \
        "${binary}"
      repo::log::progress "*"
    done
    for binary in "${nonstatics[@]:+${nonstatics[@]}}"; do
      local outfile=$(repo::golang::output_filename_for_binary "${binary}" "${platform}")
      "${GO}" build -o "${outfile}" \
        "${goflags[@]:+${goflags[@]}}" \
        -gcflags "${gogcflags}" \
        -ldflags "${goldflags}" \
        "${binary}"
      repo::log::progress "*"
    done
    repo::log::progress "\n"
  else
    # Use go install.
    if [[ "${#nonstatics[@]}" != 0 ]]; then
      "${GO}" install "${goflags[@]:+${goflags[@]}}" \
        -gcflags "${gogcflags}" \
        -ldflags "${goldflags}" \
        "${nonstatics[@]:+${nonstatics[@]}}"
    fi
    if [[ "${#statics[@]}" != 0 ]]; then
      CGO_ENABLED=0 "${GO}" install -installsuffix cgo "${goflags[@]:+${goflags[@]}}" \
        -gcflags "${gogcflags}" \
        -ldflags "${goldflags}" \
        "${statics[@]:+${statics[@]}}"
    fi
  fi
}

# Return approximate physical memory available in gigabytes.
repo::golang::get_physmem() {
  local mem

  # Linux kernel version >=3.14, in kb
  if mem=$(grep MemAvailable /proc/meminfo | awk '{ print $2 }'); then
    echo $(( ${mem} / 1048576 ))
    return
  fi

  # Linux, in kb
  if mem=$(grep MemTotal /proc/meminfo | awk '{ print $2 }'); then
    echo $(( ${mem} / 1048576 ))
    return
  fi

  # OS X, in bytes. Note that get_physmem, as used, should only ever
  # run in a Linux container (because it's only used in the multiple
  # platform case, which is a Dockerized build), but this is provided
  # for completeness.
  if mem=$(sysctl -n hw.memsize 2>/dev/null); then
    echo $(( ${mem} / 1073741824 ))
    return
  fi

  # If we can't infer it, just give up and assume a low memory system
  echo 1
}

# Build binaries targets specified
#
# Input:
#   $@ - targets and go flags.  If no targets are set then all binaries targets
#     are built.
#   REPO_BUILD_PLATFORMS - Incoming variable of targets to build for.  If unset
#     then just the host architecture is built.
repo::golang::build_binaries() {
  # Create a sub-shell so that we don't pollute the outer environment
  (
    # Check for `go` binary and set ${GOPATH}.
    repo::golang::setup_env
    V=2 repo::log::info "Go version: $(go version)"

    local host_platform
    host_platform=$(repo::golang::host_platform)

    # Use eval to preserve embedded quoted strings.
    local goflags goldflags gogcflags
    eval "goflags=(${REPO_GOFLAGS:-})"
    goldflags="${REPO_GOLDFLAGS:-} $(repo::version::ldflags)"
    gogcflags="${REPO_GOGCFLAGS:-}"

    local use_go_build
    local -a targets=()
    local arg

    for arg; do
      if [[ "${arg}" == "--use_go_build" ]]; then
        use_go_build=true
      elif [[ "${arg}" == -* ]]; then
        # Assume arguments starting with a dash are flags to pass to go.
        goflags+=("${arg}")
      else
        targets+=("${arg}")
      fi
    done

    if [[ ${#targets[@]} -eq 0 ]]; then
      targets=("${REPO_TARGETS[@]}")
    fi

    local -a platforms=(${REPO_BUILD_PLATFORMS:-})
    if [[ ${#platforms[@]} -eq 0 ]]; then
      platforms=("${host_platform}")
    fi

    local binaries
    binaries=($(repo::golang::binaries_from_targets "${targets[@]}"))

    local parallel=false
    if [[ ${#platforms[@]} -gt 1 ]]; then
      local gigs
      gigs=$(repo::golang::get_physmem)

      if [[ ${gigs} -ge ${REPO_PARALLEL_BUILD_MEMORY} ]]; then
        repo::log::status "Multiple platforms requested and available ${gigs}G >= threshold ${REPO_PARALLEL_BUILD_MEMORY}G, building platforms in parallel"
        parallel=true
      else
        repo::log::status "Multiple platforms requested, but available ${gigs}G < threshold ${REPO_PARALLEL_BUILD_MEMORY}G, building platforms in serial"
        parallel=false
      fi
    fi

    # TODO: do we actually need this?
    # First build the toolchain before building any other targets
    #repo::golang::build_kube_toolchain

    #repo::log::status "Generating bindata:" "${REPO_BINDATAS[@]}"
    #for bindata in ${REPO_BINDATAS[@]}; do
    #  # Only try to generate bindata if the file exists, since in some cases
    #  # one-off builds of individual directories may exclude some files.
    #  if [[ -f "${REPO_ROOT}/${bindata}" ]]; then
    #    go generate "${goflags[@]:+${goflags[@]}}" "${REPO_ROOT}/${bindata}"
    #  fi
    #done

    if [[ "${parallel}" == "true" ]]; then
      repo::log::status "Building go targets for {${platforms[*]}} in parallel (output will appear in a burst when complete):" "${targets[@]}"
      local platform
      for platform in "${platforms[@]}"; do (
          repo::golang::set_platform_envs "${platform}"
          repo::log::status "${platform}: go build started"
          repo::golang::build_binaries_for_platform ${platform} ${use_go_build:-}
          repo::log::status "${platform}: go build finished"
        ) &> "/tmp//${platform//\//_}.build" &
      done

      local fails=0
      for job in $(jobs -p); do
        wait ${job} || let "fails+=1"
      done

      for platform in "${platforms[@]}"; do
        cat "/tmp//${platform//\//_}.build"
      done

      exit ${fails}
    else
      for platform in "${platforms[@]}"; do
        repo::log::status "Building go targets for ${platform}:" "${targets[@]}"
        (
          repo::golang::set_platform_envs "${platform}"
          repo::golang::build_binaries_for_platform ${platform} ${use_go_build:-}
        )
      done
    fi
  )
}
