#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

INSTALL_DIR="/opt/.bin"

BINARIES='video_encode x265_encode x264_encode vp9_encode mp3_encode'

if [ -n "$1" ]; then INSTALL_DIR=$1; fi
for bin in $BINARIES; do
    rm -rf "$INSTALL_DIR/$bin" &&
    echo -en "Uninstall of $bin script - " && echo -e 'SUCESSFULL' ||
    (
        echo -e "FAILED"
        exit 1
    )
done




