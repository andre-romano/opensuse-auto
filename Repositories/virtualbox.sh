#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
#GET OPENSUSE VERSION
OS_FILE="/etc/os-release"
SUSE_VERSION="$(cat "$OS_FILE" | grep VERSION_ID | awk -F \" '{print$2}')"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

get_gpg(){
    wget -O gpg_key.asc "$1" &&
    rpm -import gpg_key.asc &&
    rm gpg_key.asc
}

get_repository(){
    wget -O /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/$1/virtualbox.repo" &&
    chmod 644 /etc/zypp/repos.d/virtualbox.repo
}

MSG="Adding $REPO_NAME"

echo -e "$MSG"
# get gpg key
get_gpg "https://www.virtualbox.org/download/oracle_vbox.asc" &&
# get vbox repository
get_repository "$SUSE_VERSION" ||
get_repository "42.1"

if [ $? -eq 0 ]; then
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
    echo -e "\t$MSG - SUCCESS\n"
    exit 0
else
    echo -e "\t$MSG - FAILED\n"
    exit 1
fi



