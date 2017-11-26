#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

#ALLOW GRE connection bypassing firewall on kernels >= 3.18
MSG="VPN PPTP Kernel Module"
VPN_CONFIG="/etc/modules-load.d/vpn.conf"

echo "#ALLOW VPN GRE CONNECTION BYPASS FIREWALL ON KERNEL >= 3.18" >> "$VPN_CONFIG" &&
echo "nf_conntrack_pptp" >> "$VPN_CONFIG" &&
chown root:root "$VPN_CONFIG" &&
chmod 644 "$VPN_CONFIG" &&
echo "$MSG - SUCCESS" ||
(echo "$MSG - FAILED" && exit 1)

