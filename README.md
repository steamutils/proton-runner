# proton-runner
[![Docker Repository on Quay](https://quay.io/repository/steamutils/proton-runner/status?token=e7714c09-d899-4026-a596-45797f70de92 "Docker Repository on Quay")](https://quay.io/repository/steamutils/proton-runner)

Container image for running windows applications on linux using Valve's Proton via GE-Proton releases provided by GloriousEggroll

## Requirements

- podman or docker

## Default Usage

### Vars
| Name | Option | Description |
| --- | --- | --- |
| STEAMCMD_ARGS | ' ... +quit' | Pass your steamcmd string here. |
| WINE_ONLY | 'true' | Changes the executor to wine |

### Mounts
| Mount Path | Required? | Description |
| --- | --- | --- |
| /steamapp | yes | Where the default workdir is set in this image, and where it's recommended to mount your application volume |

### Container Arguments


Example (Proton)
```
podman run -d --name my-app \
	-e STEAMCMD_ARGS='... ... +quit' \
	-v steamapp-volume:/steamapp:z \
	quay.io/steamutils/proton-runner:latest \
	/path/to/application.exe <<<----------------- this gets passed to entrypoint
```
Example (Wine)
```
podman run -d --name my-app \
	-e STEAMCMD_ARGS='... ... +quit' \
  -e WINE_ONLY=true \
	-v steamapp-volume:/steamapp:z \
	quay.io/steamutils/proton-runner:latest \
	/path/to/application.exe <<<----------------- this gets passed to entrypoint
```
