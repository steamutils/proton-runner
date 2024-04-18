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
	-e RUN_STEAMCMD=true
	-e STEAMCMD_ARGS='... ... +quit' \
	-v steamapp-volume:/steamapp:z \
	-v proton-volume:/proton:z \
	quay.io/steamutils/proton-runner:latest \
	/path/to/application.exe <<<----------------- this gets passed to entrypoint
```

### Examples
---
**Podman or Docker**

Doesn't install/update app when you start the application
```
podman run -d --name my-application \
        -v steamapp-123456:/steamapp:z \
        -v proton-123456:/proton:z \
        quay.io/steamutils/proton-runner:latest \
        /path/to/executable.exe
```


Does install/update the app on start
```
podman run -d --name my-application \
	-e STEAMCMD_ARGS='+@sSteamCmdForcePlatformType windows +force_install_dir /steamapp +login anonymous +app_update 123456 -public validate' \
        -v steamapp-123456:/steamapp:z \
        -v proton-123456:/proton:z \
        quay.io/steamutils/proton-runner:latest \
        /path/to/application.exe
```

---
**Kubernetes or Podman-Kube-Play**
```
cat <<EOF >> deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-application
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: my-application
        image: quay.io/steamutils/proton-runner:latest
        restartPolicy: Always
        imagePullPolicy: Always
        args: ["/path/to/executable.exe"]
	env:
	- name: STEAMCMD_ARGS
	  value: '+@sSteamCmdForcePlatformType windows +force_install_dir /steamapp +login anonymous +app_update 2278520 -public validate'
        volumeMounts:
        - mountPath: /steamapp
          name: steamapp
        - mountPath: /proton
          name: proton
      volumes:
      - name: steamapp
        persistentVolumeClaim:
          claimName: steamapp-123456 # Name of podman volume
      - name: proton
        persistentVolumeClaim:
          claimName: proton-123456 # Name of proton prefix volume      
EOF

podman kube play deployment.yaml
```

---
**With Quadlet (Systemd Service Automation)**
- Quadlet is a feature exclusive to podman, which has automated systemd generators. Just put your user-namespaced unit files in the path below.

```
cat <<EOF >> $HOME/.config/containers/systemd/my-application.kube
[Unit]
Description=My Application Kube Deployment
After=default.target

[Kube]
Yaml=/path/to/deployment.yaml
PublishPort=xxxxx-xxxxx
AutoUpdate=Registry

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

sudo loginctl enable-linger $(whoami)
systemctl --user daemon-reload
systemctl --user start my-application
```
**Enabling/Disabling start on boot**
```
sudo loginctl disable-linger $(whoami)

sudo loginctl enable-linger $(whoami)
```
**Check quadlet unit logs with journalctl**
```
journalctl --user -u my-application
```

---

## Advanced Usage
Optional Variables (Overrides)
| Variable Name | Default Value In Container | Description |
| --- | --- | --- | 
| STEAM_COMPAT_DATA_PATH | /proton | Default env var path for proton to know where to write/read bottle/prefix data. If you have a super custom pre-configured bottle you wanted to import, you could change this to a different path/mount point of your choosing. Most people don't need this and can just mount their bottle/prefix volume to this default path. |
| STEAM_COMPAT_CLIENT_INSTALL_PATH | /root/.steam | Default env var for pointing proton to where it can find steam client libraries, such as shared libraries at /root/.steam/sdk[32,64] or /root/.steam/linux[32,64]. If you want to do custom steamcmd stuff in this container, you will need to read Valve's steamcmd documentation. |
