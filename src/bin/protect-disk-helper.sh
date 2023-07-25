#!/bin/bash

mkdir -p /home/$(id -un 1000)/.local/state/pipewire
if ! mountpoint -q /home/$(id -un 1000)/.local/state/pipewire; then
  mount -t tmpfs -o size=10M,mode=755 tmpfs /home/$(id -un 1000)/.local/state/pipewire
else
  echo "Pipewire state dir is already mounted"
fi

mkdir -p /home/$(id -un 1000)/.local/state/wireplumber
if ! mountpoint -q /home/$(id -un 1000)/.local/state/wireplumber; then
  mount -t tmpfs -o size=10M,mode=755 tmpfs /home/$(id -un 1000)/.local/state/wireplumber
else
  echo "Wireplumber state dir is already mounted"
fi

chown $(id -un 1000) /home/$(id -un 1000)/.local/state/pipewire   
chown $(id -un 1000) /home/$(id -un 1000)/.local/state/wireplumber

