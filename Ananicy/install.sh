#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

ANANICY_SERVICE=/lib/systemd/system/ananicy.service

[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

PWD=$(pwd) 
zypper -n in schedtool git make gcc autoconf automake &&
cd "$SCRIPT_DIR"/ananicy &&
make -j4 install &&
systemctl daemon-reload &&
systemctl enable ananicy &&
systemctl start ananicy 
STATUS=$?
cd "$PWD"
if [ $STATUS -eq 0 ]; then
  echo -e '\n\tAll went fine, Ananicy Installed with SUCCESS\n'
else
  echo -e '\n\tAnanicy Installation - ERROR\n'
  exit $STATUS
fi

