#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# GET THE GENERAL FUNCTIONS
. "$UTILITIES_INCLUDE/general_functions.sh"

# GET THE REPOSITORY FUNCTIONS
. "$UTILITIES_INCLUDE/repository_functions.sh"

#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_NAME="libdvdcss repository"
if [ "$SUSE_VERSION" = "13.2" ]; then
    REPOSITORY="http://opensuse-guide.org/repo/13.2"
else
    REPOSITORY="http://opensuse-guide.org/repo/openSUSE_$SUSE_VERSION"
fi

verify_add_repo "$REPO_NAME" "$REPOSITORY" "1" "--no-gpg-checks" &&
display_result "Adding libdvdcss Repository"




