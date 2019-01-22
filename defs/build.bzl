# Copyright 2016 The Kubernetes Authors.
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

def _gcs_upload_impl(ctx):
    output_lines = []
    for t in ctx.attr.data:
        label = str(t.label)
        upload_path = ctx.attr.upload_paths.get(label, "")
        for f in t.files:
            output_lines.append("%s\t%s" % (f.short_path, upload_path))

    ctx.file_action(
        output = ctx.outputs.targets,
        content = "\n".join(output_lines),
    )

    ctx.file_action(
        content = "%s --manifest %s --root $PWD -- $@" % (
            ctx.attr.uploader.files_to_run.executable.short_path,
            ctx.outputs.targets.short_path,
        ),
        output = ctx.outputs.executable,
        executable = True,
    )

    return struct(
        runfiles = ctx.runfiles(
            files = ctx.files.data + ctx.files.uploader + [ctx.info_file, ctx.version_file, ctx.outputs.targets],
        ),
    )

# Adds an executable rule to upload the specified artifacts to GCS.
#
# The keys in upload_paths must match the elaborated targets exactly; i.e.,
# one must specify "//foo/bar:bar" and not just "//foo/bar".
#
# Both the upload_paths and the path supplied on the commandline can include
# Python format strings which will be replaced by values from the workspace status,
# e.g. gs://my-bucket-{BUILD_USER}/stash/{STABLE_BUILD_SCM_REVISION}
gcs_upload = rule(
    attrs = {
        "data": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
        "uploader": attr.label(
            default = Label("//defs:gcs_uploader"),
            allow_files = True,
        ),
        # TODO: combine with 'data' when label_keyed_string_dict is supported in Bazel
        "upload_paths": attr.string_dict(
            allow_empty = True,
        ),
    },
    executable = True,
    outputs = {
        "targets": "%{name}-targets.txt",
    },
    implementation = _gcs_upload_impl,
)

# Computes the md5sum of the provided src file, saving it in a file named 'name'.
def md5sum(name, src, visibility = None):
    native.genrule(
        name = name + "_genmd5sum",
        srcs = [src],
        outs = [name],
        # Currently each go_binary target has two outputs (the binary and the library),
        # so we hash both but only save the hash for the binary.
        cmd = "for f in $(SRCS); do if command -v md5 >/dev/null; then md5 -q $$f>$@; else md5sum $$f | awk '{print $$1}' > $@; fi; done",
        message = "Computing md5sum",
        visibility = visibility,
    )

# Computes the sha1sum of the provided src file, saving it in a file named 'name'.
def sha1sum(name, src, visibility = None):
    native.genrule(
        name = name + "_gensha1sum",
        srcs = [src],
        outs = [name],
        # Currently each go_binary target has two outputs (the binary and the library),
        # so we hash both but only save the hash for the binary.
        cmd = "command -v sha1sum >/dev/null && cmd=sha1sum || cmd='shasum -a1'; for f in $(SRCS); do $$cmd $$f | awk '{print $$1}' > $@; done",
        message = "Computing sha1sum",
        visibility = visibility,
    )

# Computes the sha512sum of the provided src file, saving it in a file named 'name'.
def sha512sum(name, src, visibility = None):
    native.genrule(
        name = name + "_gensha512sum",
        srcs = [src],
        outs = [name],
        # Currently each go_binary target has two outputs (the binary and the library),
        # so we hash both but only save the hash for the binary.
        cmd = "command -v sha512sum >/dev/null && cmd=sha512sum || cmd='shasum -a512'; for f in $(SRCS); do $$cmd $$f | awk '{print $$1}' > $@; done",
        message = "Computing sha512sum",
        visibility = visibility,
    )

# Creates 3+N rules based on the provided targets:
# * A filegroup with just the provided targets (named 'name')
# * A filegroup containing all of the md5, sha1 and sha512 hash files ('name-hashes')
# * A filegroup containing both of the above ('name-and-hashes')
# * All of the necessary md5sum, sha1sum and sha512sum rules
def release_filegroup(name, srcs, visibility = None):
    hashes = []
    for src in srcs:
        parts = src.split(":")
        if len(parts) > 1:
            basename = parts[1]
        else:
            basename = src.split("/")[-1]

        md5sum(name = basename + ".md5", src = src, visibility = visibility)
        hashes.append(basename + ".md5")
        sha1sum(name = basename + ".sha1", src = src, visibility = visibility)
        hashes.append(basename + ".sha1")
        sha512sum(name = basename + ".sha512", src = src, visibility = visibility)
        hashes.append(basename + ".sha512")

    native.filegroup(
        name = name,
        srcs = srcs,
        visibility = visibility,
    )
    native.filegroup(
        name = name + "-hashes",
        srcs = hashes,
        visibility = visibility,
    )
    native.filegroup(
        name = name + "-and-hashes",
        srcs = [name, name + "-hashes"],
        visibility = visibility,
    )
