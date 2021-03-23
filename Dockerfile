# Before building this, run bazel run :server_image
# Currently, this project is too big to build in Bazel on a GitHub runner

FROM bazel:server_image

RUN  /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 740 validate +quit \
    && rm -rf /opt/game/steamapps \
    && chown -R nobody:root /opt/game \
    && tar --remove-files --use-compress-program=zstd --mtime='1970-01-01' -cvf /csgo.tar.zst opt/game/ \
    && rm -rf /opt/* \
    && chown -R nobody:root /opt \
    && rm -rf /opt/game \
    && rm -rf /root/Steam \
    && rm -rf /root/.steam \
    && rmdir /tmp/dumps \
    && touch -r /var/lib/dpkg/arch /csgo.tar.zst

ENTRYPOINT ["su", "-s", "/bin/bash", "nobody", "--", "/entrypoint.sh"]