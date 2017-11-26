#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OPENSUSE_AUTO="$SCRIPT_DIR/.."
UTILITIES="$OPENSUSE_AUTO/Utilities"

INSTALL_DISTRO="$SCRIPT_DIR/Configure Distro/install.sh"

# allow scripst to run
chgrp users -R "$SCRIPT_DIR"/* &&
chmod 775 -R "$SCRIPT_DIR"/* &&
 # run distro config and installation
"$INSTALL_DISTRO" $@
