#!/bin/sh
chroot=$HOME/var/chroot/work
cd $chroot/root
sudo mount -t proc /proc proc/
sudo mount --rbind /sys sys/
sudo mount --rbind /dev dev/
sudo mount --rbind /run run/
sudo mount --bind /var/lib/dbus var/lib/dbus/
sudo mount --bind /tmp tmp/
xhost +local:
sudo chroot . /bin/bash
