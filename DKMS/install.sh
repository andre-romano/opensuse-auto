#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#add repository that contains DKMS
bash "$PACKMAN" &&
echo -e "\tInstalling DKMS... \n"
zypper -n in -l dkms kernel-devel gcc gcc-c++ make &&
systemctl enable dkms &&
systemctl start dkms &&
echo -e "\tInstallation of DKMS - SUCCESS\n" &&
exit 0
echo -e "\tInstallation of DKMS - FAILED\n"
exit 1
