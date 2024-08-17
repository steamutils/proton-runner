#!/bin/bash

podman run -d --name enshrouded \
  -e STEAMCMD_ARGS='+@sSteamCmdForcePlatformType windows +force_install_dir /steamapp +login anonymous +app_update 2278520 -public validate +quit' \
  -e WINE_ONLY=true \
  -e WINEPREFIX=/steamapp/pfx \
  -v steamapp-2278520:/steamapp:z \
  -v ./enshrouded_server.json:/steamapp/enshrouded_server.json:z \
  -p 15637:15637/udp \
  quay.io/steamutils/proton-runner:wine \
  enshrouded_server.exe
