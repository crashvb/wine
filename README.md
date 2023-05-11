# wine

[![version)](https://img.shields.io/docker/v/crashvb/wine/latest)](https://hub.docker.com/repository/docker/crashvb/wine)
[![image size](https://img.shields.io/docker/image-size/crashvb/wine/latest)](https://hub.docker.com/repository/docker/crashvb/wine)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/wine-docker.svg)](https://github.com/crashvb/wine-docker/blob/master/LICENSE.md)

## Overview

This docker image contains:

* [dbus](https://dbus.freedesktop.org/)
* [pulseaudio](https://gitlab.freedesktop.org/pulseaudio/pulseaudio)
* [winehq](https://winehq.org/)

## Entrypoint Scripts

### wine

The embedded entrypoint script is located at `/etc/entrypoint.d/wine` and performs the following actions:

1. Volume permissions are normalized.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ entrypoint.d/
│  │  └─ wine
│  └─ supervisor/
│     └─ config.d/
│        ├─ 38dbus.conf
│        ├─ 39pulseaudio.conf
│        └─ 40wine.conf
├─ home/
│  └─ wine/
│     └─ .wine/
└─ run/
   └─ secrets/
```

### Exposed Ports

None.

### Volumes

* `/home/wine/.wine` - wine configuration directory.

## Development

[Source Control](https://github.com/crashvb/wine-docker)

