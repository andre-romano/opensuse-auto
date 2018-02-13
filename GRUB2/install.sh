#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

# get help
. "$UTILITIES_INCLUDE/help.sh"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

PROG_NAME="GRUB2 and Initrd Installation/Creation"

ROOT_DIR=$1
EFI_DEVICE=$2

ROOT_DEVICE=$(mount | grep "$ROOT_DIR" | tr -s ' ' | cut -d' ' -f1)

check_help() {
    local HELP_REQUEST="true"
    if [ $# -ne 2 ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then 
        show_help "$PROG_NAME" "Installs the GRUB2 bootloader again in the machine, recreating the INITRD in the process." \
            "install.sh root [efi_device]" \
            "root\tThe root directory of the linux install that you want to generate initrd again" \
            "efi_device\tThe EFI Partition of your computer, if your BIOS is a (U)EFI one. If it's MBR one, then don't use this option, leave it empty!"
    fi    
}

create_bindings(){
    echo -e "Creating bindings for new Linux Root \"$ROOT\"..."
    for i in sys dev proc; do
        mount -o bind /$i "$ROOT/$i"
    done
}

install_grub2(){
    echo -e "Installing grub2...\n" &&
    if [ -n "$EFI_DEVICE" ]; then
        mount "$EFI_DEVICE" "$ROOT_DIR/boot/efi" &&
        chroot "$ROOT" sudo grub2-install --target=x86_64-efi --efi-directory="/boot/efi" "$ROOT_DEVICE"
    else
        chroot "$ROOT" sudo grub2-install --target=i386-pc "$ROOT_DEVICE"
    fi
}

recreate_mkinitrd(){
    echo -e "Recriating initrd ..." &&
    chroot "$ROOT" su - -c "mkinitrd" &&
    echo -e "\nMKINITRD recreation completed with SUCCESS ..."
}

release_resources(){
    if [ -n "$EFI_DEVICE" ]; then
        umount "$EFI_DEVICE"
    fi    
    for i in sys dev proc; do 
        umount "$ROOT_DIR/$i"
    done    
    cd "$ROOT_DIR/.." &&
    umount "$ROOT_DIR"
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help "$@" && 

create_bindings &&
install_grub2
if [ $? -ne 0 ]; then 
    echo -e "\n\t$PROG_NAME - FAILED"
    exit 1
fi

recreate_mkinitrd &&
release_resources &&
display_result "$PROG_NAME"



 

 
