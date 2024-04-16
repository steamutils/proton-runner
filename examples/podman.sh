#!/bin/bash
podman run -d --name my-application \
        -e EXECUTABLE_PATH=my_application.exe \
        -v steamapp-123456:/app:Z \
        -v proton-123456:/proton-prefix:Z \
        -p 15636:15636 \
        -p 15637:15637 \
        quay.io/steamutils/proton-runner:latest