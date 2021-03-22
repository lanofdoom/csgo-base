load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Download Counter-Strike: Global Offensive
#

container_run_and_extract(
    name = "counter_strike_global_offensive",
    extract_file = "/tarball.tar.zst",
    commands = [
        "/opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 740 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt",
        "apt-get update",
        "apt-get install zstd",
        "tar --remove-files --use-compress-program=zstd --mtime='1970-01-01' -cvf /tarball.tar.zst opt/game/",
    ],
    image = "@steamcmd_base//image",
)

#
# Build Image With i386 Enabled
#

container_run_and_extract(
    name = "enable_i386_sources",
    image = "@ubuntu//image",
    extract_file = "/var/lib/dpkg/arch",
    commands = [
        "dpkg --add-architecture i386",
    ],
)

container_image(
    name = "ubuntu_with_i386_packages",
    base = "@ubuntu//image",
    directory = "/var/lib/dpkg",
    files = [
        ":enable_i386_sources/var/lib/dpkg/arch",
    ],
)

#
# Server Image
#

download_pkgs(
    name = "server_deps",
    image_tar = ":ubuntu_with_i386_packages.tar",
    packages = [
        "lib32gcc1",
        "zstd",
        # TODO: Put these back in csgo-server whenever Bazel's build size issues 
        #       are worked out.
        "ca-certificates:i386",
        "libcurl4:i386",
    ],
)

install_pkgs(
    name = "server_with_deps",
    image_tar = ":ubuntu_with_i386_packages.tar",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_with_deps",
)

container_run_and_commit(
    name = "server_base",
    image = ":server_with_deps.tar",
    commands = [
        "chown -R nobody:root /opt",
    ],
)

container_image(
    name = "server_image",
    user = "nobody",
    entrypoint = ["/entrypoint.sh"],
    base = ":server_base",
    files = [
        ":counter_strike_global_offensive/tarball.tar.zst",
        "entrypoint.sh",
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