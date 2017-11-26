#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

MSG="Installation of codecs"

PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"
LIBDVDCSS="$OPENSUSE_AUTO/Repositories/libdvdcss.sh"

FFMPEG="$OPENSUSE_AUTO/ffmpeg/install.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

echo -e "Updating system to receive new codecs..."
#Making sure that all the required packages are resolved before installing codecs
bash "$PACKMAN" &&
bash "$LIBDVDCSS" &&
# zypper -n update -l --download-in-advance &&
# zypper -n dup -l --download-in-advance &&
echo "Installing codecs..." &&
zypper -n dup -l &&
zypper -n up -l &&
zypper -n in -l k3b-codecs ffmpeg lame phonon-backend-vlc phonon4qt5-backend-vlc vlc-codecs flash-player gstreamer-plugins-libav gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon gstreamer-plugins-good gstreamer-fluendo-mp3 libdvdcss2 libxine2-codecs flash-player gstreamer-plugins-base &&
bash "$FFMPEG" &&
echo "$MSG - SUCCESS" ||
( echo "$MSG - FAILED" && exit 1)
