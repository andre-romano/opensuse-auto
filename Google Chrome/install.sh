#!/bin/sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"

AUTO_UPDATE="$UTILITIES/setautoupdate.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

REPO_NAME="google-chrome"
MSG="Installation of Google Chrome"
ZYPP_BIN=google-chrome-stable

(zypper lr | grep "$REPO_NAME" > /dev/null) ||
(
    # we will use option -G to force no gpg check
    # (this should fix the GPG problems with google's repository)
    zypper -n --gpg-auto-import-keys --no-gpg-checks ar -G -f \
    "http://dl.google.com/linux/chrome/rpm/stable/x86_64" "$REPO_NAME" &&
    wget -O linux_signing_key.pub "https://dl.google.com/linux/linux_signing_key.pub" &&
    rpm -import linux_signing_key.pub &&
    rm linux_signing_key.pub
)
zypper -n in -l $ZYPP_BIN &&
"$AUTO_UPDATE" $ZYPP_BIN &&
echo -e "\n\t$MSG - SUCCESS\n" && exit 0 ||
( echo -e "\n\t$MSG - FAILED\n" && exit 1 )
