#!/bin/bash

sudo busybox devmem 0x6000d008 8 0x00
sudo modprobe mac80211

sudo insmod src/nrc.ko hifspeed=20000000 spi_bus_num=0 spi_cs_num=0 spi_gpio_irq=149 spi_polling_interval=0 fw_name=nrc7292_cspi.bin ndp_preq=1 auto_ba=0 listen_interval=1000 debug_level_all=1 disable_cqm=1 enable_short_bi=1 power_save=0

# wait until module is loaded
while ! lsmod | grep -Eq "^nrc "; do
        sleep 1;
done

# I do these commands by hand

sudo systemctl start dhcpcd
sudo systemctl start dnsmasq
sudo killall -9 wpa_supplicant &> /dev/null

# sleep 10

# sudo wpa_supplicant -i wlan0 -c misc/conf/US/sta_halow_open.conf -dddd &> wpa_supplicant.out &

# sudo insmod nrc.ko hifspeed=20000000 spi_bus_num=0 spi_cs_num=0 spi_gpio_irq=149 spi_polling_interval=0 fw_name=nrc7292_cspi.bin bss_max_idle=180 ndp_preq=1 auto_ba=1 listen_interval=1000 debug_level_all=1