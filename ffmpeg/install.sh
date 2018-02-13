#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# load help
. "$UTILITIES_INCLUDE/help.sh"

PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

BINARIES='video_encode.sh x265_encode.sh x264_encode.sh vp9_encode.sh mp3_encode.sh'

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/bin"

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then 
    show_help "FFMPEG Utilities Installer" \
        "Installs the ffmpeg utility scripts that makes a breeze transcode a video / music into common formats such as MP4 MP3 MKV with codecs H264 H265 VP9 VP8 MP3 AAC" \
        "install"
fi

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
display_result "Installation of FFMPEG Utilities"

