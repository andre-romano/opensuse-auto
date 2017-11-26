#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_NAME="Printing Repository"
REPOSITORY="http://download.opensuse.org/repositories/Printing/openSUSE_$SUSE_VERSION"

MSG="Adding Printing Repository"

#add repository
(zypper lr | grep "$REPO_NAME" > /dev/null) ||
(
    echo -e "\tAdding repository... \n" &&
    zypper -n --gpg-auto-import-keys --no-gpg-checks ar -p 2 -f \
    "$REPOSITORY" "$REPO_NAME" &&
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
)

if [ $? -eq 0 ]; then
    echo -e "\t$MSG - SUCCESS\n"
    exit 0
else
    echo -e "\t$MSG - FAILED\n"
    exit 1
fi


