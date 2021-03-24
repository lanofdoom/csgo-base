#!/bin/bash -ue

while [ true ]; do
    # Update Packages
    apt-get update && apt-get upgrade -y

    # Start Server
    /update_server.sh
    /customize_server.sh
    screen -A -m -d -S css-server sudo -E -u nobody /run_server.sh

    # Wait until maintenance hour
    current_epoch=$(date +%s)
    target_epoch=$(date --date="$UPDATE_TIME tomorrow" +%s)
    timeout_seconds=$(echo "$target_epoch - $current_epoch" | bc)
    sleep $timeout_seconds

    # Kill Server
    pkill srcds_run
    pkill srcds_linux
done
