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
        "tar --remove-files -Jcvf /tarball.tar.xz opt/game/",
    ],
    image = "@steamcmd_base//image",
)