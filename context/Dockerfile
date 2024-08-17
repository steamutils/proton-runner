FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

ARG GE_PROTON_VERSION="9-11"

RUN microdnf install -y dbus-tools python3 freetype freetype.i686 glibc.i686 libstdc++.i686 tar gzip \
	--setopt=install_weak_deps=0 \
	--setopt=tsflags=nodocs \
	&& microdnf clean all -y

RUN curl -sLOJ "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz" \
	&& tar -xzf GE-Proton*.tar.gz -C /usr/local/bin --strip-components=1 \
	&& rm -f GE-Proton*.* \
	&& rm -rf /etc/machine-id \
	&& dbus-uuidgen --ensure=/etc/machine-id \
	&& mkdir -p /steamapp && chmod -R 775 /steamapp && chown -R :0 /steamapp && chgrp -R 0 /steamapp

RUN mkdir -p /root/.steam \
	&& chmod -R 775 /root/.steam \
	&& cd /root/.steam \
	&& curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxf - \
	&& export PATH=$PATH:/root/.steam \
	&& steamcmd.sh +quit 

# Fix missing links to support applications that rely on them, such as proton
RUN ln -s /root/.steam/linux32 /root/.steam/sdk32 \
	&& ln -s /root/.steam/linux64 /root/.steam/sdk64 \
	&& ln -s /root/.steam/sdk32/steamclient.so /root/.steam/sdk32/steamservice.so \
	&& ln -s /root/.steam/sdk64/steamclient.so /root/.steam/sdk64/steamservice.so

ENV HOME /root
ENV PATH $PATH:/root/.steam:/usr/local/bin/files/bin:/usr/local/bin
ENV STEAM_COMPAT_DATA_PATH /steamapp
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH /root/.steam
ENV WINEPREFIX /steamapp/pfx
WORKDIR /steamapp
LABEL org.opencontainers.image.source=https://github.com/steamutils/runner
COPY ./entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
