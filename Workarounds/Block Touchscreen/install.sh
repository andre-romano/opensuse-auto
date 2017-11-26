 #!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# if it's not root, exit!
[ "$(whoami)" != "root" ] && echo -e "\n\tRUN this script as ROOT. Exiting...\n" && exit 1

MODPROBE_BLACKLIST=/etc/modprobe.d/50-blacklist-touch.conf

echo 'blacklist hid_multitouch' >> "$MODPROBE_BLACKLIST" &&
mkinitrd
