#!/bin/bash
date

HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -i)
PUBLIC_IP=$(ip -o -4 a | awk '$2 == "eth0" { gsub(/\/.*/, "", $4); print $4 }')

cat << EOF > /etc/rtpengine/rtpengine.conf
[rtpengine]
interface=$PUBLIC_IP
foreground=true
log-stderr=true
listen-ng=$LISTEN_NG
port-min=23000
port-max=32768
recording-dir=/tmp
recording-method=pcap
recording-format=eth
log-level=6
delete-delay=0
redis=$REDIS
EOF

if ! [ -z "$WITH_CONSUL" ]; then
    curl -X PUT \
    -d '{"ID": "'$HOSTNAME'", "Name": "rtp", "Tags": [ "rtp", "rtpengine" ], "Address": "'$IP_ADDRESS'", "Port": '$LISTEN_NG'}' \
    $CONSUL_URI:$CONSUL_PORT/v1/agent/service/register
fi

rtpengine --config-file /etc/rtpengine/rtpengine.conf
