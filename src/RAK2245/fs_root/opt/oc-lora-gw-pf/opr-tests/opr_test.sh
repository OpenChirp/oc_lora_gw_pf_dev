#!/bin/sh

sudo systemctl stop oc-lora-gw-pf.service

while true
do
    sudo rm log.txt
    sudo stdbuf -i0 -o0 -e0 sudo /opt/oc-lora-gw-pf/scripts/gwrst.sh; \
    sudo stdbuf -o0 /opt/oc-lora-gw-pf/bin/lora_pkt_fwd | sudo tee -i log.txt
done