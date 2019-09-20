#!/bin/bash

NAME=oc-lora-gw-pf

systemctl stop $NAME
systemctl disable $NAME
systemctl daemon-reload

rm -f /lib/systemd/system/$NAME.service
