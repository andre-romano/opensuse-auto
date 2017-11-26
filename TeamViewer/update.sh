#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
DOWNLOAD="http://download.teamviewer.com/download/teamviewer.i686.rpm"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

echo -e "\n\tDownloading newest version of TeamViewer\n"
wget "$DOWNLOAD" &&
echo "Installing TeamViewer" &&
zypper -n install -l -D teamviewer*.rpm &&
zypper -n install -l teamviewer*.rpm     
if [ $? -ne 0 ]; then
    rm teamviewer*.rpm 2> /dev/null
    echo -e "\n\tInstallation of TeamViewer - FAILED\n"
    exit 1
fi
rm teamviewer*.rpm 2> /dev/null
echo -e "\n\tInstallation of TeamViewer - SUCCESS\n" 
