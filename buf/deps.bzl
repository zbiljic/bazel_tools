load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_DOWNLOAD_URI = (
    "https://github.com/bufbuild/buf/releases/download/v{version}/" +
    "buf-{arch}.tar.gz"
)
_PREFIX = (
    "buf/bin"
)

_VERSION = "0.33.0"
_CHECKSUMS = {
    "Linux-x86_64": "2b063efa23e1c366779c9224ae4c5f676271cb8bf587c7aeac94b2baaaa4d4eb",
    "Darwin-x86_64": "6a3d091e6eb614d11bf1c85459e895ffe020deb22a209d535d4b7f2931934858",
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
