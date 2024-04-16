#!/bin/bash
podman run -d --name my-application \
        -v steamapp-123456:/steamapp:Z \
        -v proton-123456:/proton:Z \
	-p 15636:15636/udp \
	-p 15637:15637/udp \
	quay.io/steamutils/proton-runner:latest \
	/steamapp/path/to/application.exe
