#!/bin/bash

cd "${0%/*}" || exit 1

if ! command >&/dev/null -v inotifywait; then
  printf "Missing executabe inotifywait, do you have inotify-tools installed?\n" 
  exit 1
fi

if [[ "$EUID" != 0 ]]; then
  printf "Please give me root privileges by running me with sudo or doas.\n"
  exit 1
fi

BEAMYHOME="$(realpath ..)"
if [[ -z "$BEAMYHOME" ]]; then
  printf "Could not get location of beamylabs-start.\n"
  exit 1
fi

FALLBACK="$(whoami)"
BEAMYUSER="${SUDO_USER:-${DOAS_USER:-${FALLBACK}}}"
if [[ -z "$BEAMYUSER" ]]; then
  printf "Could not get real user running the script.\n"
  exit 1
fi

sed >/etc/systemd/system/beamylabs-upgrade.service \
    -e "s,@BEAMYHOME@,$BEAMYHOME,g" \
    -e "s,@BEAMYUSER@,$BEAMYUSER,g" \
    beamylabs-upgrade.service.tmpl

systemctl daemon-reload
systemctl stop beamylabs-upgrade || true
systemctl enable beamylabs-upgrade
systemctl start beamylabs-upgrade || true
