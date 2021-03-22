#!/bin/bash -ue

if [ ! -d /opt/game/csgo ]
then
    tar -xvf tarball.tar.zst
fi

/opt/game/srcds_run
    -game csgo
    -tickrate 128
    +map de_dust2
    -strictbindport