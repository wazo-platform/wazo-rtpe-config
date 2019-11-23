#!/bin/bash
date
wait-for -t 60 $ROUTER_CONFD_URI
wait-for -t 60 $CONSUL_URI
sleep 2

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

curl -X PUT \
    -d '{"ID": "'$HOSTNAME'", "Name": "rtp", "Tags": [ "rtp", "rtpengine" ], "Address": "'$IP_ADDRESS'", "Port": '$LISTEN_NG'}' \
    http://${CONSUL_URI}/v1/agent/service/register

rtpengine --config-file /etc/rtpengine/rtpengine.conf
date
