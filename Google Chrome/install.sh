#!/bin/sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

AUTO_UPDATE="$UTILITIES/setautoupdate.sh"

. "$UTILITIES_INCLUDE/general_functions.sh"

. "$UTILITIES_INCLUDE/repository_functions.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_NAME="google-chrome"
ZYPP_BIN=google-chrome-stable

get_gpg "https://dl.google.com/linux/linux_signing_key.pub" &&
verify_add_repo "google-chrome" "http://dl.google.com/linux/chrome/rpm/stable/x86_64" "99" "--no-gpg-checks" &&
zypper -n in -l $ZYPP_BIN &&
"$AUTO_UPDATE" $ZYPP_BIN &&
display_result "Installation of Google Chrome"
