#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

AUTO_UPDATE="$UTILITIES/setautoupdate.sh"

PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"
LIBDVDCSS="$OPENSUSE_AUTO/Repositories/libdvdcss.sh"
KERNEL="$OPENSUSE_AUTO/Repositories/kernel.sh"

ANANICY="$OPENSUSE_AUTO/Ananicy/install.sh"
GOOGLE_CHROME="$OPENSUSE_AUTO/Google Chrome/install.sh"
UNISON="$OPENSUSE_AUTO/Unison/install.sh"
BAOBAB="$OPENSUSE_AUTO/Baobab/install.sh"

# now we will declare the packages we want to install

# updatable packages (will run autoupdate on these)
ZYPP_UPDATABLE="youtube-dl smplayer kodi vlc gimp MozillaFirefox MozillaThunderbird dropbox speedcrunch keepassx libreoffice xsane"

# X11 drivers
ZYPP_XF86='xf86-input-evdev xf86-input-joystick xf86-input-keyboard xf86-input-libinput xf86-input-mouse xf86-input-synaptics xf86-input-vmmouse xf86-video-amdgpu xf86-video-intel xf86-video-nouveau xf86-video-vesa'
# compression software
ZYPP_COMPAC='rar unrar p7zip gzip lzip zip pigz'
# fuse and filesystems
ZYPP_FUSE='libfsntfs1 pam_mount cryptsetup ecryptfs-utils exfat-utils fuse-exfat fusesmb ifuse gparted'
# multimedia libraries and software
ZYPP_MULTIMEDIA='ffmpeg libmp3lame0 libfdk-aac1 libfaac0 mediainfo x264 youtube-dl caffeine smplayer gimp kodi vlc'
# utilities software
ZYPP_UTILITIES='MozillaFirefox MozillaThunderbird dropbox speedcrunch kate keepassx autossh sshfs autofs pdftk aria2 uget nodejs ghostscript ghostscript-fonts'
# system software
ZYPP_SYSTEM='sni-qt sni-qt-32bit pavucontrol pv fcoe-utils open-lldp fetchmsttfonts kdegraphics-thumbnailers'

# join everything in one variable
ZYPP="$ZYPP_SYSTEM $ZYPP_UTILITIES $ZYPP_MULTIMEDIA $ZYPP_FUSE $ZYPP_COMPAC $ZYPP_XF86"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# update first to allow zypper, yast and bash to work properly
zypper -n up -l &&
bash "$LIBDVDCSS" &&
bash "$PACKMAN" &&
bash "$KERNEL" &&
echo -e "\n\tUpdating operational system and programs...\n" &&
zypper -n dup -l --download-in-advance &&
zypper -n patch -l &&
zypper -n update -l --download-in-advance &&
echo -e "\n\tUpdate completed - SUCCESS\n" &&
echo -e "Installation of additional programs..." &&
zypper -n install -l $ZYPP &&
"$AUTO_UPDATE" "$ZYPP_UPDATABLE" &&
bash "$ANANICY" && # ananicy auto nice daemon
bash "$BAOBAB" &&  # install disk usage analiser
bash "$GOOGLE_CHROME" && # install google chrome web browser
bash "$UNISON" && # establish ulimits on heavyweight sync program
echo -e "\n\t$MSG - SUCCESS\n" &&
zypper clean ||
(echo -e "\n\t$MSG - FAILED\n" && exit 1)
