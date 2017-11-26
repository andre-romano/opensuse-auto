#!/bin/bash
# returns a comma separated list of all installed packages
sudo rpm -qa --qf "%{NAME}," | tee installed.packages
find /etc/zypp/repos.d/ -type f -exec cat '{}' \; | grep url | awk -F = '{print$2}' | tee installed.repositories
echo -e "\n\tInformation extracted SUCCESSFULLY to \"installed.packages\" and \"installed.repositories\"\n"
