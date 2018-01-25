#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

CURRENT_DESKTOP="$(env | grep CURRENT_DESKTOP | awk -F = '{print$2}')"

#SOFTWARE INSTALL
DKMS="$OPENSUSE_AUTO/DKMS/install.sh"

#INSTALL SCRIPTS
    UPDATE_KERNEL="$SCRIPT_DIR/update_kernel.sh"
    UPDATE_FILE="$SCRIPT_DIR/updatesys.sh"
    CODECS_FILE="$SCRIPT_DIR/codecs.sh"
    GRAPHICS_FILE="$SCRIPT_DIR/graphics_drivers.sh"
    SNAPSHOTS_FILE="$SCRIPT_DIR/limit_snapshots.sh"
    DISABLE_SEARCH="$SCRIPT_DIR/disable_desktop_search.sh"
    CLEAR_TMP="$SCRIPT_DIR/clear_tmp.sh"
    DNS="$SCRIPT_DIR/dns.sh"
    SWAPPINESS_FILE="$SCRIPT_DIR/swappiness.sh"

#TOOLS
    LUKS="$OPENSUSE_AUTO/luks/install.sh"
    ISO="$OPENSUSE_AUTO/isomount/install.sh"
    PDF="$OPENSUSE_AUTO/pdf/install.sh"

#WORKAROUNDS FOR COMMON ISSUES OF KERNEL/OPENSUSE/DRIVERS
    MOUSE_MSFT="$OPENSUSE_AUTO/Workarounds/Mouse Fast Scroll - Microsoft/install.sh"
    SUSPEND="$OPENSUSE_AUTO/Workarounds/Suspend/install.sh"
    WIFI="$OPENSUSE_AUTO/Workarounds/Wifi Performance/install.sh"
    VPN="$OPENSUSE_AUTO/Workarounds/VPN Kernel Allow/install.sh"    
    HDD="$OPENSUSE_AUTO/Workarounds/Storage Tuning/install.sh"
    # NOT USED ANYMORE
    BUMBLEBEE="$OPENSUSE_AUTO/Workarounds/NVIDIA Optimus/install.sh"
    BLUETOOTH="$OPENSUSE_AUTO/Workarounds/Bluetooth RFKILL Unlock/install.sh"
    SCREEN="$OPENSUSE_AUTO/Workarounds/Fix Screen Issues (RANDR)/install.sh"    

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# show options to the user
if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "--h" ]; then
    echo -e "\n\topenSUSE Installation Automation Tool\n"
    echo -e "\nOPTION\tDESCRIPTION\n"
    echo -e "-k\tUpdate kernel to latest stable (use it only if necessary - missing drivers, malfunctional hardware, performance issues, etc)\n\n"
    exit 0
fi

# read user defined variables
for var in "$@"; do
    case "$var" in
        -k) KERNEL_SHOULD_UPDATE=y
            ;;
    esac
done

STATUS=""
LOG_FILE="install.log"
COUNTER=0

# insert done or failed depending on the return status
insert_status() {
  # $1 is the main string to display
  if [ $? -ne 0 ]; then
    STATUS="$STATUS[$COUNTER] $1 - FAILED\n"
  else
    STATUS="$STATUS[$COUNTER] $1 - DONE\n"
  fi
  COUNTER=$(($COUNTER+1))
}

#install useful tools in system
install_tools(){
    #install luks tools
    bash "$LUKS"
    insert_status "TOOLS\n\tLUKS TOOLS - "

    #install iso mount tools
    bash "$ISO"
    insert_status "\tISO TOOLS - "

    #install pdf tools
    bash "$PDF"
    insert_status "\tPDF TOOLS - "
}

#install workarounds
install_workarounds(){
    # fix suspend problems with some ACPI machines (specifically those with NVIDIA GPU's)
    bash "$SUSPEND"
    insert_status "WORKAROUNDS\n\tSUSPEND WORKAROUND - "

    #disable baboo search to spare cpu and IO (increse PC performance)
    bash "$DISABLE_SEARCH"
    insert_status "\tDISABLE BABOO SEARCH - "

    # reduce btrfs snapshots
    bash "$SNAPSHOTS_FILE"
    insert_status "\tREDUCE SNAPSHOTS - "]

    #clear tmp files on boot
    bash "$CLEAR_TMP"
    insert_status "\tCLEAR TEMPORARY FILES AT BOOT - "

    #allow vpn pptp with kernel >= 3.18
    bash "$VPN"
    insert_status "\tALLOW VPN PPTP CONNECTIONS ON KERNEL >= 3.18 - "

    #use better default dns to speed internet speed
    bash "$DNS"
    insert_status "\tDNS CHANGE TO SAFE AND FAST PROVIDER - "

    #fix microsoft mouse driver problems
    bash "$MOUSE_MSFT"
    insert_status "\tMICROSOFT MOUSE - "

    #fix wifi performance driver problems
    bash "$WIFI"
    insert_status "\tWIFI PERFORMANCE - "

    #install dkms to provide better support to kernel compiled modules (like VirtualBox and NVIDIA)
    bash "$DKMS"
    insert_status "\tDKMS INSTALL - "

    # avoid multi-screen bugs in KDE and other X11 desktops
    bash "$SCREEN"
    insert_status "AVOID SCREEN PROBLEMS (XRANDR) - "

    # activate auto-update script (run updates automagically)
    bash "$SWAPPINESS_FILE"
    insert_status "TUNE SWAPPINESS FOR DESKTOP - "

    # improve hdd / ssd and other storages performance
    bash "$HDD"
    insert_status "STORAGE TUNNING SCRIPT - "

#   NOT NEEDED WORKAROUNDS ANYMORE (NEW SYSTEMS / KERNEL CORRECT THIS PROBLEMS)

#    bash "$BLUETOOTH"
#    insert_status "BLUETOOTH RFKILL UNBLOCK - "
    # bash "$PANELS"
    # insert_status "AVOID WINDOWS UNDER PANELS - "

}

#install graphics drivers
install_graphics(){
#   DO NOT INSTALL GRAPHICS (NVIDIA / AMD AND OPTIMUS PROPRIETARY DRIVERS ARE NO GOOD FOR LINUX, OPENSOURCE IS BETTER :) )
    return 0
#    bash "$GRAPHICS_FILE" "$GRAPHICS_CARD"
#    insert_status "GRAPHICS DRIVERS - "
#    check_n_execute "$OPTIMUS" "$BUMBLEBEE" "$USER"
#    insert_status "NVIDIA OPTIMUS - "
}

#update system
update_system(){
    #update whole system
    bash "$UPDATE_FILE"
    insert_status "SYSTEM UPDATE - "

    # check if kernel update is really needed
    if [ "$KERNEL_SHOULD_UPDATE" == "y" ]; then
        #update kernel
        bash "$UPDATE_KERNEL"
        insert_status "\tUPDATE KERNEL - "
    fi
}

#install codecs
install_codecs(){
    #install multimedia codecs
    bash "$CODECS_FILE"
    insert_status "CODECS INSTALL - "
}

install_tools
install_workarounds
install_graphics
update_system
install_codecs
echo -e "\n\t======== INSTALLATION REPORT =========\n$STATUS" | tee "$LOG_FILE"
echo -e "\n\tDistribution configuration complete. Have fun :) \n"
