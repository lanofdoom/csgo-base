#!/bin/bash -ue

/opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 740 validate +quit

chown -R nobody:root /opt/game
