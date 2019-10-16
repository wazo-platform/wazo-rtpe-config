#!/bin/bash
date

PUBLIC_IP=$(ip -o -4 a | awk '$2 == "eth0" { gsub(/\/.*/, "", $4); print $4 }')
sed -i -e "s/interface=PUBLIC_IP/interface=$PUBLIC_IP/g" /etc/rtpengine/rtpengine.conf

rtpengine --config-file /etc/rtpengine/rtpengine.conf
