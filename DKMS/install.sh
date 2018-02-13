#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

PACKMAN="$OPENSUSE_AUTO/Repositories/packman.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="Installation of DKMS"

#add repository that contains DKMS
bash "$PACKMAN" &&
echo -e "\tInstalling DKMS... \n"
zypper -n in -l dkms kernel-devel gcc gcc-c++ make &&
systemctl enable dkms &&
systemctl start dkms &&
display_result "Installation of DKMS"
