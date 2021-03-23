#!/bin/bash -ue

while [ true ]; do
    # Start Server
    /update_server.sh
    sudo -u nobody /customize_server.sh
    screen -A -m -d -S css-server sudo -u nobody /run_server.sh

    # Wait until maintenance hour
    current_epoch=$(date +%s)
    target_epoch=$(date --date="$UPDATE_TIME tomorrow" +%s)
    timeout_seconds=$(echo "$target_epoch - $current_epoch" | bc)
    sleep $timeout_seconds

    # Update packages and kill server
    apt-get update && apt-get upgrade -y
    pkill srcds_run
    pkill srcds_linux
done
