FROM quay.io/steamutils/steamcmd:latest

RUN microdnf install -y dbus-tools python3 freetype freetype.i686 \
	--setopt=install_weak_deps=0 \
	--setopt=tsflags=nodocs \
	&& microdnf clean all -y 

ARG GE_PROTON_VERSION="9-2"
RUN curl -sLOJ "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz" \
	&& tar -xzf GE-Proton*.tar.gz -C /usr/local/bin --strip-components=1 \
	&& rm -f GE-Proton*.* \
	&& rm -rf /etc/machine-id \
	&& dbus-uuidgen --ensure=/etc/machine-id \
	&& mkdir -p /proton-prefix && chmod -R 775 /proton-prefix && chown -R :0 /proton-prefix && chgrp -R 0 /proton-prefix \
	&& mkdir -p /app && chmod -R 775 /app && chown -R :0 /app && chgrp -R 0 /app

ENV APP_MOUNT /app
ENV STEAM_COMPAT_DATA_PATH=/proton-prefix 
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH /root/.steam
COPY ./entrypoint /entrypoint
WORKDIR /app
LABEL org.opencontainers.image.source=https://github.com/steamutils/proton-runner
ENTRYPOINT ["/entrypoint"]
