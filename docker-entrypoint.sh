#!/bin/bash
date
if ! [ -z "$CONSUL_URI" ]; then
    wait-for -t 60 $CONSUL_URI
    sleep 2
fi

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

# register/de-register service in consul
curl -i -X PUT http://${CONSUL_URI}/v1/agent/service/register -d '{
    "ID": "'$HOSTNAME'",
    "Name": "rtp",
    "Tags": ["rtp", "rtpengine"],
    "Address": "'$IP_ADDRESS'",
    "Port": '$LISTEN_NG'
}'
exit_script() {
    curl -X PUT http://${CONSUL_URI}/v1/agent/service/deregister/$HOSTNAME
    killall rtpengine
    date
    exit 143; # 128 + 15 -- SIGTERM
}
trap exit_script SIGINT SIGTERM

# run rtpengine
rtpengine --config-file /etc/rtpengine/rtpengine.conf &

# wait for signals
while true; do sleep 1; done

# exit
exit_script
