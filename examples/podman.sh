#!/bin/bash
podman volume exists steamapp-2278520 || podman volume create steamapp-2278520

chmod 775 ./enshrouded_server.json

podman run -d --name enshrouded \
  -e STEAMCMD_ARGS='+@sSteamCmdForcePlatformType windows +force_install_dir /steamapp +login anonymous +app_update 2278520 -public validate +quit' \
  -v steamapp-2278520:/steamapp:z \
  -v ./enshrouded_server.json:/steamapp/enshrouded_server.json:z \
  -p 15637:15637/udp \
  quay.io/steamutils/proton-runner:latest \
  enshrouded_server.exe
