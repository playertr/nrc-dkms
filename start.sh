#!/bin/bash

sudo busybox devmem 0x6000d008 8 0x00
sudo modprobe mac80211
sudo ./misc/nrc_load_module.sh

# I do these commands by hand

# sudo systemctl start dhcpcd
# sudo systemctl start dnsmasq
# sudo killall -9 wpa_supplicant
# sudo wpa_supplicant -i wlan0 -c misc/conf/US/sta_halow_open.conf -dddd &> wpa_supplicant.out &