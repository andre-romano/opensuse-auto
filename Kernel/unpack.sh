#!/bin/bash
[ "$(whoami)" != 'root' ] && echo 'RUN THIS AS ROOT' && exit 1

LINUX_KERNEL="$1"
DEST="$2"

if [ -z "$DEST" ]; then
    DEST=/usr/src
fi

zypper -n install libelf-devel autoconf rpm-build gcc ncurses-devel ncurses-utils libncurses5 libncurses6 make automake fakeroot git perl flex bison &&
tar -xavf "$LINUX_KERNEL" -C "$DEST"

