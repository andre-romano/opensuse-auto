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

get_gpg "https://www.virtualbox.org/download/oracle_vbox.asc" &&
verify_add_repo "VirtualBox" "http://download.virtualbox.org/virtualbox/rpm/opensuse/$SUSE_VERSION/virtualbox.repo" \
    "99" "--no-gpg-checks" &&
display_result "Adding VirtualBox repository"



