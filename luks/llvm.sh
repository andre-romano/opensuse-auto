#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1
int='^[0-9]+$'

PROG_NAME="LUKS over LVM"

#general purpose variables
DEV="/dev/mapper"
MOUNTPOINT="/run/media/root"

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "$PROG_NAME"
    echo -e "\n\tUsage: llvm root_dir device mapper_name\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\troot_dir\tRoot directory of the Linux install"
    echo -e "\tdevice\tThe device that you want to format with LUKS and put LVM inside it"
    echo -e "\tmapper_name\tThe name of the mapped decrypted device that you want"
    echo -e "\nUsage:\nllvm / /dev/sda1 encrypted"
    exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
    show_help
fi

raise_error() {
    echo -e "\n\t$PROG_NAME - FAILED"
    echo -e "$1"
    if [ -n "$2" ]; then rm "$2" 2> /dev/null; fi #remove file if needed
    exit 1
}

MAPPER_NAME=$3
DEVICE=$2
ROOT=$1
LVM_SUFFIX=_LVM
LVM="$MAPPER_NAME""$LVM_SUFFIX"
echo -e "WARNING: All data contained in \"$DEVICE\" will be lost! Press OK to continue or Ctrl+C to stop..." && read
echo "Formatting device for LUKS..." &&
cryptsetup -y luksFormat "$DEVICE" ||
raise_error "\tFormatting device \"$DEVICE\" for LUKS Header Layer - FAILED"
cryptsetup luksOpen "$DEVICE" "$MAPPER_NAME" ||
raise_error "\tOpenning LUKS device \"$DEVICE\" - FAILED"
DEV="$DEV/$MAPPER_NAME"
echo "Creating physical volume and volume group of LVM..." &&
pvcreate "$DEV" && vgcreate "$LVM" "$DEV" &&
DEV="$DEV$LVM_SUFFIX" &&
echo -e "\tNow please proceed to \"lvm_create\" to create the required logical volumes. The volume group is \"$LVM\"
Once done press OK to continue..." &&
read &&
echo -e "Setting crypttab for automounting the encrypted partition/device..." &&
UUID=$(blkid | grep "$DEVICE" | awk -F \  '{print$2}' | awk -F \" '{print$2}') &&
echo -e "$MAPPER_NAME\tUUID=$UUID\tnone\tluks" >> "$ROOT/etc/crypttab" ||
raise_error "Could not set crypttab at \"$ROOT\"!"
echo -e "\tNow you need to go to $ROOT/etc/fstab and add the logical volumes that you've created outside this script...
When you're done press OK..." &&
read &&
echo -e "Proceeding with the INITRD generation..." &&
$SCRIPT_DIR/gen_initrd.sh "$ROOT" &&
echo -en "\tDo you want to keep the partitions decrypted so that you can mount and copy your information back to them? (type YES or NO) " &&
read PROMPT &&
if [ "$PROMPT" != "YES" ]; then
    echo -e "\n\tAlright, in this case please execute the command \"mount $DEV-<NAME_OF_LOGICAL_VOLUME> <DIR>\"
to mount the logical volume specified inside the folder DIR. Please note that you may need to create the folder
prior to mounting the device (you can do this using the command \"mkdir <DIR>\")."
    echo -e "\n\tAll operations finished. Script finished!"
else
    vgchange -a n && cryptsetup luksClose
fi
if [ $? -eq 0 ]; then
    echo -e "\t$PROG_NAME - SUCCESSFUL\n" && exit 0
else
    echo -e "\t$PROG_NAME - FAILED\n" && exit 1 
fi

