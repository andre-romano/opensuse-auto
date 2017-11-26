#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
DKMS="$OPENSUSE_AUTO/DKMS/install.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

ADD_USER_FILE="$SCRIPT_DIR/vbox_adduser.sh"
VIRTUALBOX_US="vboxgtk"
ADD_USER="n"
if [ $# -gt 2 || $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then
    echo -e "\n\tUsage: vbox_install_ose -INTERFACE USER"
    echo -e "\tOR"
    echo -e "\n\tUsage: vbox_install_ose -INTERFACE\n"
    echo -e "\tINTERFACE: g=gnome, k=kde, o=others\n"
    exit 1
elif [ $# -eq 2 ]; then
    ADD_USER="y"
fi
if [ "$1" = "-k" ]; then
    VIRTUALBOX_US="virtualbox-qt"
fi
echo "Iniciando instalacao do VirtualBox" 
bash "$DKMS" #install dkms
sudo zypper -n install -l virtualbox "$VIRTUALBOX_US" &&
echo -e "\n\tInstalacao do VirtualBox concluida com SUCESSO\n" &&
if [ "$ADD_USER" = "y" ]; then
    bash "$ADD_USER_FILE" "$1"    
fi
