# buf

Bazel rule for [`buf`](https://github.com/bufbuild/buf) tool ([https://buf.build](https://buf.build)).

## Setup and usage via Bazel

You can invoke buf via the Bazel rule.

`WORKSPACE` file:

```bzl
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "com_github_zbiljic_bazel_tools",
    commit = "<commit>",
    remote = "https://github.com/zbiljic/bazel_tools.git",
    shallow_since = "<bla>",
)

load("@com_github_zbiljic_bazel_tools//buf:deps.bzl", "buf_dependencies")

buf_dependencies()
```

`BUILD.bazel` typically in the workspace root:

```bzl
load("@com_github_zbiljic_bazel_tools//buf:def.bzl", "buf")

buf(
    name = "buf"
)
```

Invoke with

```bash
bazel run //:buf
```
