#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

PROG_NAME="Grub2 and Initrd Installation/Creation"

#OPTIONS
EFI=-e
ALL_OPTIONS=$EFI

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "$PROG_NAME"
    echo -e "\n\tUsage: install.sh root [options]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\troot\tThe root directory of the linux install that you want to generate initrd again"    
    echo -e "\t$EFI\tUse this option in case your system has an EFI BIOS. If your computer is MSDOS based then don\'t set this option."
    exit 0
}

check_help() {
    if [ $# -eq 0 ]; then return 0; fi #at least one file is needed
    for var in "$@"; do
        HELP_REQUEST="true"
        for option in "$ALL_OPTIONS"; do #check for all options provided
            if [ "$var" = "$option" ]; then
                HELP_REQUEST="false"
                break
            fi
        done
        if [ -e "$var" ]; then HELP_REQUEST="false"; fi #check if all files provided exist
        if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done
    return 1
}

ROOT=$1
EFI=$2
DEVICE=$(mount | grep "$ROOT " | awk -F \  '{print$1}') 
#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help "$@" && show_help

while [ "$FSTAB" != "yes" ]; do 
    echo -en "Have you updated the /etc/fstab file for the root directory \"$ROOT\"? (Type \"yes\" to proceed)" &&
    read FSTAB 
done
echo -e "Creating bindings for new Linux Root \"$ROOT\"..." && exit 0
for i in sys dev proc; do mount --bind /$i "$ROOT/$i"; done &&
echo -e "Installing grub2...\n" &&
if [ "$EFI" = "-e" ]; then
    chroot "$ROOT" sudo grub2-install --target=x86_64-efi --efi-directory="/boot/efi" $DEVICE
else
    chroot "$ROOT" sudo grub2-install --target=i386-pc $DEVICE
fi
if [ $? -ne 0 ]; then (echo -e "\n\t$PROG_NAME - FAILED" && exit 1); fi
echo -e "Recriating mkinitrd..." &&
chroot "$ROOT" su - -c "mkinitrd" &&
echo -e "\nMKINITRD recreation completed with SUCCESS, releasing resources..." &&
for i in sys dev proc; do umount "$ROOT/$i"; done &&
echo -e "\n\t$PROG_NAME - SUCCESS" ||
(echo -e "\n\t$PROG_NAME - FAILED" && exit 1)



 

 
