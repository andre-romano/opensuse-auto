#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

[ "$(whoami)" != 'root' ] && echo 'ERROR: RUN THIS SCRIPT AS ROOT!' && exit 1

echo '
# set PROGRAM DIRTY BYTES (LOWER MEANS BETTER RESPONSIVITY AND LOWER THROUGHPUT)
vm.dirty_bytes=536870912
vm.dirty_background_bytes=268435456

# define how agressive is the swapping (lower means less swap, more programs in memory)
vm.swappiness=30

# define the priority of programs related to data (lower means more priority to data)
vm.vfs_cache_pressure=50
' >> /etc/sysctl.d/99-sysctl.conf &&
echo -e '\n\tTweaks applied with SUCCESS\n'