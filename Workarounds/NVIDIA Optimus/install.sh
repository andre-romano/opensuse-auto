#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

DKMS="$OPENSUSE_AUTO/DKMS/install.sh"
ADD_USER="$SCRIPT_DIR/bumblebee_adduser.sh"
SUSE_VERSION="$("$UTILITIES/suse_version.sh")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then
    echo -e "\n\tNVIDIA OPTIMUS Bumblebee Installation Script\n"
    echo -e "\tUsage: install USER [USER2 [..]]\n"
    exit 0
fi
if [ "$(whoami)" != "root" ]; then
    echo -e "\n\tRUN this script as ROOT. Exiting...\n"
    exit 1
fi
if [ "$(arch)" = "x86_64" ]; then PACKAGES_64="nvidia-bumblebee-32bit"; fi #check for 64 bit OS
#add required repositories and install dkms
zypper -n --gpg-auto-import-keys --no-gpg-checks ar -f \
"http://download.opensuse.org/repositories/X11:/Bumblebee/openSUSE_$SUSE_VERSION/" \
"Bumblebee NVIDIA" 2> /dev/null
bash "$DKMS" #install DKMS
#install nvidia bumblebee drivers
zypper -n in -l bumblebee nvidia-bumblebee "$PACKAGES_64" &&
systemctl enable bumblebeed &&
bash "$ADD_USER" $@ &&
systemctl start bumblebeed &&
mkinitrd &&
echo -e "\n\tNVIDIA OPTIMUS - Bumblebee for Linux - Installation - OK\n" &&
echo -e "\n\tYou may need to restart your computer to complete installation\n" &&
exit 0
echo -e "\n\tNVIDIA OPTIMUS - Bumblebee for Linux - Installation - FAILED\n"
exit 1
