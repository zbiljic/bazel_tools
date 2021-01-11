load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_DOWNLOAD_URI = (
    "https://github.com/bufbuild/buf/releases/download/v{version}/" +
    "buf-{arch}.tar.gz"
)
_PREFIX = (
    "buf/bin"
)

_VERSION = "0.35.1"
_CHECKSUMS = {
    "Linux-x86_64": "c8ec48056319a890874f3d132b0c5747d68d50c84a5d77c5ba931cc49a153e28",
    "Darwin-x86_64": "22f15fa4d9cf75ee413a4eeec4dca7030e8e2c6215430d2d47570162bdc8023f",
}

def _buf_download_impl(ctx):
    if ctx.os.name == "linux":
        arch = "Linux-x86_64"
    elif ctx.os.name == "mac os x":
        arch = "Darwin-x86_64"
    else:
        fail("Unsupported operating system: {}".format(ctx.os.name))

    if arch not in _CHECKSUMS:
        fail("Unsupported arch {}".format(arch))

    url = _DOWNLOAD_URI.format(version = _VERSION, arch = arch)
    prefix = _PREFIX.format(version = _VERSION, arch = arch)
    sha256 = _CHECKSUMS[arch]

    ctx.template(
        "BUILD.bazel",
        Label("@com_github_zbiljic_bazel_tools//buf:buf.build.bazel"),
        executable = False,
    )
    ctx.download_and_extract(
        stripPrefix = prefix,
        url = url,
        sha256 = sha256,
    )

_buf_download = repository_rule(
    implementation = _buf_download_impl,
)

def buf_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )
    _buf_download(
        name = "com_github_zbiljic_bazel_tools_buf",
    )
