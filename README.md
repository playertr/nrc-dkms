# nrc-dkms

Teledatics Debian DKMS package repository for the Newracom nrc7292_sw_pkg driver.

Modified for Jetson Nano.

# Set up on Jetson Nano

Build kernel module with
```
dpkg-buildpackage -us -uc
```

Install with
```
cd ..
sudo apt install ./nrc-dkms_1.34.11_all.deb
```

Configure SPI pins with device tree overlay (see .dts file for platform-specific notes).
```
cd nrc-dkms/misc/dts
dtc -O dtb -o jetson_nrc7292.dtbo jetson_nrc7292.dts
sudo cp jetson_nrc7292.dtbo /boot
sudo /opt/nvidia/jetson-io/config-by-hardware.py -n "Prepare SPI0 for NRC Driver"
```

# Run on Jetson Nano

To run, first specify that the SPI pins should be SFIO instead of GPIO [^1]
```
sudo busybox devmem 0x6000d008 8 0x00
```

Then load the mac80211 module
```
sudo modprobe mac80211
```

Then load the nrc module
```
sudo ./misc/nrc_load_module.sh
```

Isn't that just nasty?

[^1]: [source](https://forums.developer.nvidia.com/t/cannot-get-spi-to-work/183855), [more info](https://forums.developer.nvidia.com/t/gpio-to-sfio-28-1/52594)