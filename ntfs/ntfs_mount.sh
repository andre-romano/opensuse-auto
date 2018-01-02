#!/bin/bash

NTFS_LIST=/etc/ntfs_to_mount.conf
NTFS_OPTIONS="users,gid=users,umask=000"

[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2018 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "NTFS Fixer and Mounter"
    echo -e "\tUsage: ntfs_mount\n"
    echo -e "This script requires ROOT and tries to fix common NTFS problems related to bad blocks and corruption flags. If this operation is a "
    echo -e "success, the script will mount the NTFS partition. Therefore, this script IS NOT A REPAIR UTILITY. It is a"
    echo -e "workaround common problems with NTFS, that prohibit it from mounting successfully under Linux. With that said, this script "
    echo -e "can be used instead of the /etc/fstab to automount NTFS partitions. This can avoid boot issues"
    echo -e "when the partition has bad blocks or is flagged as corrupted."
    echo -e "Keep in mind that if the problem is severe (there is a real corruption of the partition, or Windows has Hibernated),"
    echo -e "the script WILL NOT BE ABLE TO MOUNT the NTFS partition,"
    echo -e "thus requiring a full run of Windows NTFS repair program (called chkdsk) over the partition (this"
    echo -e "could take quite a while to finish and might require full system reboots to complete). \n"
    echo -e "This script reads the file \"$NTFS_LIST\" searching for NTFS partitions to mount on boot. The file format is as follows (without the double quotes):"
    echo -e "\"device mountpoint\"\n"
    echo -e "device\tThe name or UUID of the NTFS partition "
    echo -e "mountpoint is\tThe complete absolute filepath to mount the partition (the folder should exist)"
    exit 0
}

if [ "$1" == '-h' ] || [ "$1" == '-help' ] || [ "$1" == '--help' ]; then
  show_help
fi

while IFS='' read -r line || [[ -n "$line" ]]; do
    DEV=$(echo $line | cut -d' ' -f1)
    MOUNTPOINT=$(echo $line | cut -d' ' -f2-)
    if echo "$DEV" | grep UUID &> /dev/null; then
      UUID=$(echo $DEV | sed 's/UUID=//gi' | xargs)
      DEV='/dev/'$(lsblk -o NAME,UUID | grep "$UUID" | cut -d' ' -f1 | sed 's/[^A-Za-z0-9]//gi')
    fi
    ntfsfix -b -d "$DEV"
    mount -t ntfs "$DEV" "$MOUNTPOINT" -o "$NTFS_OPTIONS"
done < "$NTFS_LIST"
