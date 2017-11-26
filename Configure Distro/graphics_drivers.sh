#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
DKMS="$OPENSUSE_AUTO/DKMS/install.sh"

SUSE_VERSION="$("$UTILITIES/suse_version.sh")"
SUSE_VERSION=${SUSE_VERSION//_/\/} # replace all _ for /
SUSE_VERSION=${SUSE_VERSION,,} #to lowercase

MSG="Installation of GPU Drivers"
OTHER_OPTION="-o"
NVIDIA_OPTION="-n"
AMD_OPTION="-a"

# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# remove_vdpau() {
# #     zypper -n rm vdpau* libvdpau*
#     echo "DUMMY REMOVE VDPAU - FOR NOW"
# }

if [ "$1" = "$NVIDIA_OPTION" ] || [ "$1" = "$AMD_OPTION" ] || [ "$1" = "$OTHER_OPTION" ]; then
    if [ "$1" = "$NVIDIA_OPTION" ]; then
        REPO_NAME="nVidia Graphics Drivers"
        REPOSITORY="http://download.nvidia.com/opensuse/$SUSE_VERSION"
    elif [ "$1" = "$AMD_OPTION" ]; then
        if [ "$(arch)" = "x86_64" ]; then
            GRAPHICS_DRIVER="http://geeko.ioda.net/mirror/amd-fglrx/ymp/amd-ati-fglrx64.ymp"
        else
            GRAPHICS_DRIVER="http://geeko.ioda.net/mirror/amd-fglrx/ymp/amd-ati-fglrx.ymp"
        fi
        # remove_vdpau
    else
        # remove_vdpau
        echo -e "GPU Drivers - NO CHANGES NEEDED"
        exit 0
    fi
    echo -e "\n\Installing drivers...\n" &&
    bash "$DKMS" && #install dkms to operate well with new kernel drivers

    #old procedure
    # OCICLI "http://opensuse-community.org/$GRAPHICS_DRIVER" <<< "y"
    if [ "$1" = "$NVIDIA_OPTION" ]; then #INSTALL NVIDIA
        (zypper lr | grep "$REPO_NAME" > /dev/null) ||
        (
            echo -e "\tAdding repository... \n" &&
            zypper -n --gpg-auto-import-keys --no-gpg-checks ar -f \
            "$REPOSITORY" "$REPO_NAME" &&
            zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
        )
        if [ $? -ne 0 ]; then
            zypper -n inr
        else
            echo -e "\n\tCould not add NVIDIA repository. Terminating..."
            exit 1
        fi
    else #install AMD DRIVERS
        OCICLI "http://opensuse-community.org/$GRAPHICS_DRIVER" <<< "y"
    fi

    if [ $? -eq 0 ]; then
        echo -e "\n\t$MSG - SUCCESS\n"
        exit 0
    else
        echo -e "\n\t$MSG - FAILED\n"
        exit 1
    fi
else
    echo -e "\n\tUsage: graphics_drivers.sh OPTIONS\n"
    echo -e "\n\tOPTIONS:"
    echo -e "\t-n\tNVIDIA Drivers"
    echo -e "\t-a\tAMD Drivers\n"
    if [ "$1" = "-h" ] || [ "$1" = "--h" ] || [ "$1" = "--help" ]; then
        exit 0
    fi
    exit 1
fi
