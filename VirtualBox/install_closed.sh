#!/bin/bash
#RUN THIS SCRIPT AS ROOT
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

DKMS="$OPENSUSE_AUTO/DKMS/install.sh"
VIRTUALBOX_REPOSITORY="$OPENSUSE_AUTO/Repositories/virtualbox.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

ADD_USER_FILE="$SCRIPT_DIR/vbox_adduser.sh"

if [ $# -gt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then
    echo -e "\n\tUsage: vbox_install_closed USER"
    echo -e "\tOR"
    echo -e "\n\tUsage: vbox_install_closed\n"
    exit 1
fi
#add repository
echo "Iniciando instalacao do VirtualBox" &&
zypper -n rm virtualbox* 2> /dev/null #remove incompatible VirtualBox OSE
#install DKMS
bash "$DKMS" 
#install VirtualBox PUEL
bash "$VIRTUALBOX_REPOSITORY" 
VBOX_INSTALL="VirtualBox-"
VBOX="$(zypper search "$VBOX_INSTALL" | grep "$VBOX_INSTALL" | tail -n 1 | awk -F \| '{print$2}' | awk '$1=$1')" &&
zypper -n install -l "$VBOX" &&
echo -e "\n\tInstalacao do VirtualBox concluida com SUCESSO\n" &&
/etc/init.d/vboxdrv setup && #install drivers
# echo -e "\n\tInstalando extensao USB 2.0\n" &&
# VBOX_USB2="$(wget -q "$OFFICIAL_URL" -O- | grep "Oracle VM VirtualBox Extension Pack" | awk -F \" '{print$4}')" &&
# wget "$VBOX_USB2" && VBoxManage extpack install ${VBOX_USB2##*/} &&
# echo -e "\n\tInstalacao da extensao VirtualBox USB 2.0 concluida com SUCESSO\n"
# rm ${VBOX_USB2##*/}
if [ -n "$1" ]; then bash "$ADD_USER_FILE" "$1"; fi     
