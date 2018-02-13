#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/../.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
UTILITIES_INCLUDE="$OPENSUSE_AUTO/Utilities - Include only"

. "$UTILITIES_INCLUDE/general_functions.sh"
. "$UTILITIES_INCLUDE/modprobe_functions.sh"

# load kernel module that allows VPN PPTP
load_module "nf_conntrack_pptp" "vpn.conf" &&
display_result "VPN PPTP Kernel Module"

