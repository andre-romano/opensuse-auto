#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

[ "$(whoami)" != 'root' ] && echo 'ERROR: RUN THIS SCRIPT AS ROOT!' && exit 1

echo '
# MEMORY MANAGEMENT

# cache (higher means more cache)
vm.dirty_background_ratio=20
vm.dirty_ratio=40

# (lower means less swap, more programs in memory)
vm.swappiness=30

# define the priority of programs related to data (lower means more priority to data)
vm.vfs_cache_pressure=50

# NETWORK 

# memory used to rebuild IP fragments (in bytes)
net.ipv4.ipfrag_high_thresh = 8388608
net.ipv4.ipfrag_low_thresh = 6291456

# write queue (in bytes)
net.core.wmem_default = 212992
net.core.wmem_max = 8388608
# tcp write buffer = min (default), pressure, max (in bytes)
net.ipv4.tcp_wmem = 4096 131072 8388608

# read queue (in bytes)
net.core.rmem_default = 212992
net.core.rmem_max = 8388608
# tcp read buffer = min (default), pressure, max (in bytes)
net.ipv4.tcp_rmem = 4096 174760 8388608

' >> /etc/sysctl.d/99-sysctl.conf &&
echo -e '\n\tTweaks applied with SUCCESS\n'