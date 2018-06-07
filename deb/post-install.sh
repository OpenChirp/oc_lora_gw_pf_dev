#!/bin/bash

NAME=oc-lora-gw-pf-dev

# eanble SPI interface
raspi-config nonint do_spi 0

cp -f /opt/$NAME/service/$NAME.service /lib/systemd/system/$NAME.service

systemctl daemon-reload
systemctl enable $NAME
systemctl start $NAME
