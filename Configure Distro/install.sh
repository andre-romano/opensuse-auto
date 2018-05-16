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

#TOOLS
    LUKS="$OPENSUSE_AUTO/luks/install.sh"
    ISO="$OPENSUSE_AUTO/isomount/install.sh"
    PDF="$OPENSUSE_AUTO/pdf/install.sh"

#WORKAROUNDS FOR COMMON ISSUES OF KERNEL/OPENSUSE/DRIVERS
    MOUSE_MSFT="$OPENSUSE_AUTO/Workarounds/Mouse Fast Scroll - Microsoft/install.sh"
    SUSPEND="$OPENSUSE_AUTO/Workarounds/Suspend/install.sh"
    WIFI="$OPENSUSE_AUTO/Workarounds/Wifi Performance/install.sh"
    PULSE_AUDIO="$OPENSUSE_AUTO/Workarounds/PulseAudio Jack Detection/install.sh"
    VPN="$OPENSUSE_AUTO/Workarounds/VPN Kernel Allow/install.sh"    
    HDD="$OPENSUSE_AUTO/Workarounds/Storage Tuning/install.sh"
    # NOT USED ANYMORE
    BUMBLEBEE="$OPENSUSE_AUTO/Workarounds/NVIDIA Optimus/install.sh"
    BLUETOOTH="$OPENSUSE_AUTO/Workarounds/Bluetooth RFKILL Unlock/install.sh"
    SCREEN="$OPENSUSE_AUTO/Workarounds/Fix Screen Issues (RANDR)/install.sh"    
    TWEAKS_KERNEL="$OPENSUSE_AUTO/Kernel/tweaks.sh"

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
run_script() {
    local SCRIPT_TO_RUN="$1"
    local MSG="$2"

    bash "$SCRIPT_TO_RUN" &&
    STATUS="$STATUS[$COUNTER] $2 - DONE\n" || 
    STATUS="$STATUS[$COUNTER] $2 - FAILED\n"    
    COUNTER=$(($COUNTER+1))
}

#install useful tools in system
install_tools(){
    #install luks tools
    run_script "$LUKS" "TOOLS\n\tLUKS TOOLS - "

    #install iso mount tools
    run_script "$ISO" "\tISO TOOLS - "

    #install pdf tools
    run_script "$PDF" "\tPDF TOOLS - "
}

#install workarounds
install_workarounds(){
    # fix suspend problems with some ACPI machines (specifically those with NVIDIA GPU's)
    run_script "$SUSPEND" "WORKAROUNDS\n\tSUSPEND WORKAROUND - "

    #disable baboo search to spare cpu and IO (increse PC performance)
    run_script "$DISABLE_SEARCH" "\tDISABLE BABOO SEARCH - "

    # reduce btrfs snapshots
    run_script "$SNAPSHOTS_FILE" "\tREDUCE SNAPSHOTS - "

    #clear tmp files on boot
    run_script "$CLEAR_TMP" "\tCLEAR TEMPORARY FILES AT BOOT - "

    #allow vpn pptp with kernel >= 3.18
    run_script "$VPN" "\tALLOW VPN PPTP CONNECTIONS ON KERNEL >= 3.18 - "

    #use better default dns to speed internet speed
    run_script "$DNS" "\tDNS CHANGE TO SAFE AND FAST PROVIDER - "

    #fix microsoft mouse driver problems
    run_script "$MOUSE_MSFT" "\tMICROSOFT MOUSE - "

    #fix wifi performance driver problems
    run_script "$WIFI" "\tWIFI PERFORMANCE - "

    # FIX PULSE AUDIO NOT DETECTING HEADPHONE ON BOOT
    run_script "$PULSE_AUDIO" "\tPULSE AUDIO AUDIO JACK DECTECTION ON BOOT - "

    #install dkms to provide better support to kernel compiled modules (like VirtualBox and NVIDIA)
    run_script "$DKMS" "\tDKMS INSTALL - "

    # avoid multi-screen bugs in KDE and other X11 desktops
    run_script "$SCREEN" "AVOID SCREEN PROBLEMS (XRANDR) - "

    # activate auto-update script (run updates automagically)
    run_script "$TWEAKS_KERNEL" "TUNE KERNEL FOR DESKTOP - "

    # improve hdd / ssd and other storages performance
    run_script "$HDD" "STORAGE TUNNING SCRIPT - "

#   NOT NEEDED WORKAROUNDS ANYMORE (NEW SYSTEMS / KERNEL CORRECT THIS PROBLEMS)

#    run_script "$BLUETOOTH" "BLUETOOTH RFKILL UNBLOCK - "
#    run_script "$PANELS" "AVOID WINDOWS UNDER PANELS - "

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
    run_script "$UPDATE_FILE" "SYSTEM UPDATE - "

    # check if kernel update is really needed
    if [ "$KERNEL_SHOULD_UPDATE" == "y" ]; then
        #update kernel
        run_script "$UPDATE_KERNEL" "\tUPDATE KERNEL - "
    fi
}

#install codecs
install_codecs(){
    #install multimedia codecs
    run_script "$CODECS_FILE" "CODECS INSTALL - "
}

install_tools
install_workarounds
install_graphics
update_system
install_codecs
echo -e "\n\t======== INSTALLATION REPORT =========\n$STATUS" | tee "$LOG_FILE"
echo -e "\n\tDistribution configuration complete. Have fun :) \n"
