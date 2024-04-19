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
	&& mkdir -p /proton && chmod -R 775 /proton && chown -R :0 /proton && chgrp -R 0 /proton \
	&& mkdir -p /steamapp && chmod -R 775 /steamapp && chown -R :0 /steamapp && chgrp -R 0 /steamapp

ENV HOME /root
ENV STEAM_COMPAT_DATA_PATH=/proton 
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH /root/.steam
WORKDIR /steamapp
LABEL org.opencontainers.image.source=https://github.com/steamutils/proton-runner
COPY ./entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
