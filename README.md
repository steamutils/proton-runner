# proton-runner
[![Docker Repository on Quay](https://quay.io/repository/steamutils/proton-runner/status?token=e7714c09-d899-4026-a596-45797f70de92 "Docker Repository on Quay")](https://quay.io/repository/steamutils/proton-runner)

Container image for running windows applications on linux using Valve's Proton via GE-Proton releases provided by GloriousEggroll

## Requirements

- podman or docker

## Default Usage

### Vars
| Variable Name | Required? | Example |
| --- | --- | --- |
| EXECUTABLE_PATH | yes | application.exe |

### Mounts
| Mount Path | Required? | Description |
| --- | --- | --- |
| /app | yes | Where you should mount your Steamapp volume. The entrypoint sets $APP_MOUNT to /app by default and will execute `proton runinprefix $APP_MOUNT/$EXECUTABLE_PATH` as the default entrypoint. |
| /proton-prefix | yes | Where Proton has the default container prefix path set to via `$STEAM_COMPAT_DATA_PATH`. If you have built a custom bottle/proton prefix and wish to mount it, this is where it would go. |

### Examples
---
**Podman or Docker**
```
podman run -d --name my-application \
        -e EXECUTABLE_PATH=my_application.exe \
        -v steamapp-123456:/app:Z \
        -v proton-123456:/proton-prefix:Z \
        -p 15636:15636 \
        -p 15637:15637 \
        quay.io/steamutils/proton-runner:latest
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
        env:
        - name: EXECUTABLE_PATH
          value: my_application.exe
        volumeMounts:
        - mountPath: /app
          name: steamapp
        - mountPath: /proton-prefix
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
PublishPort=15636-15637
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
| STEAM_COMPAT_DATA_PATH | /proton-prefix | Default env var path for proton to know where to write/read bottle/prefix data. If you have a super custom pre-configured bottle you wanted to import, you could change this to a different path/mount point of your choosing. Most people don't need this and can just mount their bottle/prefix volume to this default path. |
| STEAM_COMPAT_CLIENT_INSTALL_PATH | /root/.steam | Default env var for pointing proton to where it can find steam client libraries, such as shared libraries at /root/.steam/sdk[32,64] or /root/.steam/linux[32,64]. If you want to do custom steamcmd stuff in this container, you will need to read Valve's steamcmd documentation. |
| APP_MOUNT | /app | Default WORKDIR of the container. If you wish to change this moint point without causing problems, make sure to set `--workdir` in your run/deployment to whatever path you're mounting your app to. |
| RUN_SCRIPT | | I added a `source $RUN_SCRIPT` directive in the entrypoint for advanced users that may want to bolt-on their own tooling to this without having to rebuild their own image. Use at your discretion. |
