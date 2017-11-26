#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MSG="eCryptfs Installation"

#GENERAL CONFIG VARIABLES
INSTALL_DIR="/usr/sbin"
SUDOERS_LUKS="/etc/sudoers.d/ecryptfs"
LUKS_CMND_ALIAS="ECRYPTFS_CMD"

#OPTIONS SECTION
NO_SUDOERS_OPTION="-S"
ALL_OPTIONS=$NO_SUDOERS_OPTION

show_copywrite() {
    echo -e "\n$1"
    echo -e "Copyright © 2015 Andre Luiz Romano Madureira.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo -e "This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law\n"
}

show_help() {
    show_copywrite "eCryptfs Utilities Installer"
    echo -e "\n\tUsage: install [options]\n"
    echo -e "\tOPTION\tDESCRIPTION"
    echo -e "\t$NO_SUDOERS_OPTION\tDo not create Sudoers entries to avoid root password"        
    exit 0
}

check_help() {        
    for var in "$@"; do
	HELP_REQUEST="true"
	for option in "$ALL_OPTIONS"; do
	    if [ "$var" = "$option" ]; then HELP_REQUEST="false"; fi
	done
	if [ "$HELP_REQUEST" = "true" ]; then return 0; fi
    done    
    return 1
}

#CHECK FOR INCORRECT ARGUMENTS OR HELP REQUEST
check_help $@ && show_help

if [ "$1" = "$NO_SUDOERS_OPTION" ]; then
    echo -e "WARNING: No Sudoers entry option selected. These eCryptfs script utilities will require root permission and it's password to run!"
    SUDOERS_LUKS="/dev/null" #send echo stdout redirection to null device
fi

cpy_install() {
    COUNTER=1
    echo -n "Cmnd_Alias $LUKS_CMND_ALIAS = " > $SUDOERS_LUKS
    for var in "$@"; do	
	ORIGIN_FILE="$SCRIPT_DIR/$var"
	DEST_FILE="$INSTALL_DIR/$(basename "$var" .sh)"
	cp "$ORIGIN_FILE" "$DEST_FILE" &&
	chown root:root "$DEST_FILE" && chmod 755 "$DEST_FILE" &&
	echo -n "$DEST_FILE" >> $SUDOERS_LUKS &&
	if [ $COUNTER -ne $# ]; then echo -n ", " >> $SUDOERS_LUKS ;
	else echo -n -e "\n" >> $SUDOERS_LUKS; fi
	COUNTER=$(($COUNTER+1))
    done    
}

echo -e "Installing and configuring eCryptfs for PAM support... [ 1/3 ]\n" &&
zypper -n in -l ecryptfs-utils &&
pam-config -a --ecryptfs &&
echo -e "Activating eCryptfs kernel modules (modprobe)... [ 2/3 ]\n" &&
modprobe ecryptfs &&
# echo -e "Copying scripts for opening and closing eCryptfs folders... [ 3/3 ]\n" &&
# cpy_install eclose.sh eopen.sh &&
# #AVOID ROOT PASSWORD FOR LUKS OPERATIONS
# echo -e "%users ALL=(root) NOPASSWD: $LUKS_CMND_ALIAS" >> $SUDOERS_LUKS &&
echo -e "$MSG - SUCCESS" && exit 0 ||
(echo -e "$MSG - FAILED" && exit 1)
