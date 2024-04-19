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


### Mounts
| Mount Path | Required? | Description |
| --- | --- | --- |
| /steamapp | yes | Where the default workdir is set in this image, and where it's recommended to mount your application volume |
| /proton | yes | Where Proton has the default container prefix path set to via `$STEAM_COMPAT_DATA_PATH`. If you have built a custom bottle/proton prefix and wish to mount it, this is where it would go. |

### Container Arguments

The container's entrypoint in `context/entrypoint` just runs `proton runinprefix "$@"` which means whatever you put at the end of the run statement gets passed to proton.

Example
```
podman run -d --name my-app \
	-e STEAMCMD_ARGS='... ... +quit' \
	-v steamapp-volume:/steamapp:z \
	-v proton-volume:/proton:z \
	quay.io/steamutils/proton-runner:latest \
	/path/to/application.exe <<<----------------- this gets passed to entrypoint
```
## Examples

See [examples](examples/) for podman and kube deployment resources
