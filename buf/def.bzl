load("@bazel_skylib//lib:shell.bzl", "shell")

def _buf_impl(ctx):
    args = []
    if ctx.attr.config:
        args.append("--config={}".format(ctx.file.config.short_path))

    out_file = ctx.actions.declare_file(ctx.label.name + ".bash")
    substitutions = {
        "@@BUF_SHORT_PATH@@": shell.quote(ctx.executable._buf.short_path),
        "@@ARGS@@": shell.array_literal(args),
    }
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = out_file,
        substitutions = substitutions,
        is_executable = True,
    )
    transitive_depsets = []
    default_runfiles = ctx.attr._buf[DefaultInfo].default_runfiles
    if default_runfiles != None:
        transitive_depsets.append(default_runfiles.files)

    runfiles = ctx.runfiles(
        transitive_files = depset(transitive = transitive_depsets),
    )
    return [DefaultInfo(
        files = depset([out_file]),
        runfiles = runfiles,
        executable = out_file,
    )]

_buf = rule(
    implementation = _buf_impl,
    attrs = {
        "config": attr.label(
            allow_single_file = True,
            doc = "The config file or data to use",
        ),
        "_buf": attr.label(
            default = "@com_github_zbiljic_bazel_tools_buf//:tool",
            cfg = "host",
            executable = True,
        ),
        "_runner": attr.label(
            default = "@com_github_zbiljic_bazel_tools//buf:runner.bash.template",
            allow_single_file = True,
        ),
    },
    executable = True,
)

def buf(**kwargs):
    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags.append("manual")
        kwargs["tags"] = tags
    _buf(
        **kwargs
    )
