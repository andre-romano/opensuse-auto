#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# GET SUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

zypper -n --gpg-auto-import-keys --no-gpg-checks ar -f \
"http://download.opensuse.org/repositories/home:Heinervdm:branches:Education/openSUSE_$SUSE_VERSION/" \
"Fritzing" 2> /dev/null &&
zypper -n --gpg-auto-import-keys --no-gpg-checks refresh &&
zypper -n in -l fritzing &&
display_result "Installation of Fritzing"

