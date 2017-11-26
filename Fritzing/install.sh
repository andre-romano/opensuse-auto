#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
zypper -n --gpg-auto-import-keys --no-gpg-checks ar -f \
"http://download.opensuse.org/repositories/home:Heinervdm:branches:Education/openSUSE_$SUSE_VERSION/" \
"Fritzing" 2> /dev/null &&
zypper -n --gpg-auto-import-keys --no-gpg-checks refresh &&
zypper -n in -l fritzing &&
echo -e "\tInstallation of Fritzing - SUCCESS\n" &&
exit 0
echo -e "\tInstallation of Fritzing - FAILED\n"
exit 1
