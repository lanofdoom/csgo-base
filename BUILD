load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_extract")

#
# Install deps
#

download_pkgs(
    name = "server_deps",
    image_tar = "@steamcmd_base//image",
    packages = [
        "bc",
        "sudo",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = "@steamcmd_base//image",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/entrypoint.sh"],
    env = {
        "TZ": "America/Chicago",
        "UPDATE_TIME": "03:00",
    },
    files = [
        ":customize_server.sh",
        ":entrypoint.sh",
        ":run_server.sh",
        ":update_server.sh",
    ],
)

container_push(
   name = "push_server_image",
   image = ":server_image",
   format = "Docker",
   registry = "ghcr.io",
   repository = "lanofdoom/csgo-base/csgo-base",
   tag = "latest",
)