#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UTILITIES="$SCRIPT_DIR/../Utilities"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

# CHANGE DEFAULT DNS FROM NETCONF /etc/sysconfig/network/config to STATIC predefined as GOOGLE 8.8.8.8 / 8.8.8.4

MSG="DNS CONFIGURATION"

NETCONF_CONFIG=/etc/sysconfig/network/config
# NETCONF_CONFIG_BAK=$NETCONF_CONFIG.bak

DNS="208.67.220.220 8.8.8.8 200.175.5.139"

change_netconfig() {
    sed -i.bak "s/$1=\".*/$1=\"$2\"/" "$NETCONF_CONFIG"
}

# cp "$NETCONF_CONFIG" "$NETCONF_CONFIG_BAK" &&

#DO NOT CHANGE DNS TO MANUAL, KEEP IT AS STATIC_FALLBACK IN CASE NETWORK-MANAGER CANNOT RESOLVE THE ADDRESSES

#change_netconfig "NETCONFIG_DNS_POLICY" "STATIC Network-Manager" &&

change_netconfig "NETCONFIG_DNS_STATIC_SERVERS" "$DNS" &&
echo -e "$MSG - SUCCESSFUL" &&
echo -e "DNS CHANGED TO = $DNS" ||
(echo -e "$MSG - FAILED" && exit 1)
