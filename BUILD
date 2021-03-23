load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_extract")

#
# Build Image With i386 Enabled
#

container_run_and_extract(
    name = "enable_i386_sources",
    image = "@steamcmd_base//image",
    extract_file = "/var/lib/dpkg/arch",
    commands = [
        "dpkg --add-architecture i386",
    ],
)

container_image(
    name = "steamcmd_with_i386_packages_and_entrypoint",
    base = "@steamcmd_base//image",
    directory = "/var/lib/dpkg",
    files = [
        ":enable_i386_sources/var/lib/dpkg/arch",
    ],
)

#
# Install deps
#

download_pkgs(
    name = "server_deps",
    image_tar = ":steamcmd_with_i386_packages_and_entrypoint.tar",
    packages = [
        # "lib32gcc1",
        "zstd",
        # TODO: Put these back in csgo-server whenever Bazel's build size issues 
        #       are worked out.
        "ca-certificates:i386",
        "libcurl4:i386",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = ":steamcmd_with_i386_packages_and_entrypoint.tar",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

container_image(
    name = "server_image",
    base = ":server_base",
    files = [
        ":entrypoint.sh",
    ],
)