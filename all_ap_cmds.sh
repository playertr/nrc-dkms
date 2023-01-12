sudo /home/pi/nrc_pkg/script/conf/etc/clock_config.sh
sudo killall -9 wpa_supplicant
sudo killall -9 hostapd
sudo killall -9 wireshark-gtk
sudo rmmod nrc
sudo rm /home/pi/nrc_pkg/script/conf/temp_self_config.conf
sudo sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat --flush
sudo iptables --flush
sudo systemctl stop dhcpcd
sudo systemctl stop dnsmasq
sudo /home/pi/nrc_pkg/sw/firmware/copy 7292 nrc7292_bd.dat
/home/pi/nrc_pkg/script/conf/etc/ip_config.sh AP 1 0
modinfo nrc >/dev/null 2>/dev/null
modinfo nrc >/dev/null 2>/dev/null
sudo modprobe nrc  hifspeed=20000000 spi_bus_num=0 spi_cs_num=0 spi_gpio_irq=5 spi_polling_interval=0 fw_name=uni_s1g.bin bd_name=nrc7292_bd.dat power_save=0 bss_max_idle=180 auto_ba=1 listen_interval=1000 credit_ac_be=40
/home/pi/nrc_pkg/script/cli_app set txpwr 24
/home/pi/nrc_pkg/script/cli_app set bdf_use on
/home/pi/nrc_pkg/script/cli_app set gi long
/home/pi/nrc_pkg/script/cli_app set cal_use on
sudo systemctl start dhcpcd
sudo systemctl start dnsmasq
sed -i "4s/.*/interface=wlan0/g"  /home/pi/nrc_pkg/script/conf/US/ap_halow_open.conf 
sudo hostapd /home/pi/nrc_pkg/script/conf/US/ap_halow_open.conf  &
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo ifconfig
