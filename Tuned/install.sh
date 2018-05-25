#!/bin/bash

[ $(whoami) != root ] && echo 'RUN AS ROOT' && exit 1

zypper -n in -l tuned &&
systemctl enable tuned &&
systemctl start tuned &&
tuned-adm profile network-latency &&
echo 'Tuned installation - SUCCESS' ||
(
  echo 'Tuned installation - FAILED'
  exit 2
)
