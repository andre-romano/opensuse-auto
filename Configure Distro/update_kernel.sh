#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"
#GET OPENSUSE VERSION
SUSE_VERSION="$(bash "$UTILITIES/suse_version.sh")"

MSG="Installation of codecs"

KERNEL="$OPENSUSE_AUTO/Kernel/install.sh"

echo "\nInstalling new kernel...\n" &&
bash "$KERNEL"
