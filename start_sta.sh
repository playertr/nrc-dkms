#!/bin/bash

sudo systemctl start dhcpcd
sudo systemctl start dnsmasq
sudo killall -9 wpa_supplicant &> /dev/null
sudo wpa_supplicant -i wlan0 -c misc/conf/US/sta_halow_open.conf -dddd | ts &> wpa_supplicant.out &