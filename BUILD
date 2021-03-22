load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_extract")

#
# Download Counter-Strike: Global Offensive
#

container_run_and_extract(
    name = "counter_strike_global_offensive",
    extract_file = "/tarball.tar.xz",
    commands = [
        "/opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 740 validate +quit",
        "rm -rf /opt/game/steamapps",
        "apt-get update",
        "apt-get install xz-utils",
        "XZ_OPT='-T0 -1' tar --remove-files -cvJf /tarball.tar.xz opt/game/",
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
        # TODO: Put these back in csgo-server whenever Bazel's build size issues 
        #       are worked out.
        "ca-certificates:i386",
        "libcurl4:i386",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = ":ubuntu_with_i386_packages.tar",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

container_image(
    name = "server_image",
    user = "nobody",
    entrypoint = ["/opt/game/srcds_run", "-game csgo", "-tickrate 128", "+map de_dust2", "-strictbindport"],
    base = "server_base.tar",
    tars = [
        ":counter_strike_global_offensive/tarball.tar.xz",
    ],
)

container_push(
   name = "push_server_image",
   image = ":server_image",
   format = "Docker",
   registry = "ghcr.io",
   repository = "lanofdoom/counterstrikesourceglobaloffensive-base/counterstrikesourceglobaloffensive-base",
   tag = "latest",
)