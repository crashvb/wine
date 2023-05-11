FROM crashvb/x11:202303201341@sha256:524df83a1510cd07681cf3afa5c915f7603719c39938f71be7255b9dde23c02a
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:524df83a1510cd07681cf3afa5c915f7603719c39938f71be7255b9dde23c02a" \
	org.opencontainers.image.base.name="crashvb/x11:202303201341" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing wine." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/wine-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/wine" \
	org.opencontainers.image.url="https://github.com/crashvb/wine-docker"

# Install packages, download files ...
# hadolint ignore=DL3009,DL4006
RUN docker-apt-install gnupg && \
	APT_ARCHITECTURES="i386 amd64" apt-add-repo "winehq" https://dl.winehq.org/wine-builds/ubuntu/ main D43F640145369C51D786DDEA76F1A20FF987672F && \
	dpkg --add-architecture i386 && \
	apt-get update && \
	docker-apt \
		dbus \
		dbus-x11 \
		pulseaudio \
		tzdata \
		winehq-stable \
		winetricks

# Configure: dbus
RUN install --directory --group=root --mode=0755 --owner=root /run/dbus && \
	rm --force /var/lib/dbus/machine-id

# Configure: pulseaudio
RUN sed --expression="/.ifexists module-console-kit.so/,+2d" --in-place=.dist /etc/pulse/default.pa

# Configure: wine
ENV WINE_DATA=/home/wine/.wine WINE_GID=1000 WINE_HOME=/home/wine WINE_UID=1000 X11_GNAME=wine X11_UNAME=wine
RUN groupadd --gid=${WINE_GID} ${X11_GNAME} && \
	useradd --create-home --gid=${WINE_GID} --groups=ssl-cert --home-dir=${WINE_HOME} --shell=/bin/bash --uid=${WINE_UID} ${X11_UNAME}

# Configure: supervisor
COPY *-wrapper /usr/local/bin/
COPY supervisord.dbus.conf /etc/supervisor/conf.d/38dbus.conf
COPY supervisord.pulseaudio.conf /etc/supervisor/conf.d/39pulseaudio.conf

# Configure: entrypoint
COPY entrypoint.wine /etc/entrypoint.d/wine

VOLUME ${WINE_DATA}
