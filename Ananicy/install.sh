#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

PWD=$(pwd) 
zypper -n in schedtool git make gcc autoconf automake &&
git clone 'https://github.com/Nefelim4ag/Ananicy.git' "$SCRIPT_DIR"/src &&
cd "$SCRIPT_DIR"/src &&
make -j4 install &&
# the systemd module of ananicy is NOT WORKING (we'll use xdg-autostart desktop instead)
systemctl disable ananicy &&
cp "$SCRIPT_DIR/ananicy.desktop" /etc/xdg/autostart/ &&
chmod 644 /etc/xdg/autostart/ananicy.desktop
STATUS=$?
cd "$PWD"
if [ $STATUS -eq 0 ]; then
  echo -e '\n\tAll went fine, Ananicy Installed with SUCCESS\n'
else
  echo -e '\n\tAnanicy Installation - ERROR\n'
  exit $STATUS
fi

