#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

BINARIES='video_encode.sh x265_encode.sh x264_encode.sh vp9_encode.sh mp3_encode.sh'

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/opt/.bin"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "FFMPEG Utilities Installer"
    echo -e "\n\tUsage: install [directory]\n"
    exit 0
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then show_help; fi

# check for custom install dir
if [ -n "$1" ]; then INSTALL_DIR=$1; fi
# CHECK DIR
mkdir -p "$INSTALL_DIR"
INSTALL_DIR_OWN=$(ls -ld "$INSTALL_DIR" | tr -s ' ' | cut -d' ' -f3)
INSTALL_DIR_GRP=$(ls -ld "$INSTALL_DIR" | tr -s ' ' | cut -d' ' -f4)
# INSTALL FFMPEG
bash "$PACKMAN" &&
sudo zypper -n in -l mediainfo ffmpeg libmp3lame0 libfdk-aac1 libfaac0
# COPY BINARIES TO THE INSTALL DIR
for bin in $BINARIES; do
    BIN_NAME=$(echo "$INSTALL_DIR/"$(basename -s .sh $bin))
    cp "$SCRIPT_DIR/$bin" "$INSTALL_DIR" &&
    mv "$INSTALL_DIR/$bin" "$BIN_NAME" &&
    chown "$INSTALL_DIR_OWN":"$INSTALL_DIR_GRP" "$BIN_NAME" &&
    chmod 755 "$BIN_NAME"
done

echo -en "Installation of ffmpeg scripts - " && echo -e 'SUCCESSFUL' ||
(
    echo -e 'FAILED'
    exit 1
)

