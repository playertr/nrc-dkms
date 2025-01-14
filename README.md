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

Further instructions are in start.sh.

[^1]: [source](https://forums.developer.nvidia.com/t/cannot-get-spi-to-work/183855), [more info](https://forums.developer.nvidia.com/t/gpio-to-sfio-28-1/52594)

# Implementation details
I had to learn a bit to get this to work. Here are the largest points of learning, summarized.

Unlike some other device drivers, this WiFi driver requires special SPI communications features  and network drivers that require it to be built into the kernel (rather than in "userspace"). More details are in the "Host driver porting" PDF from Newracom. While Newracom provides a [Linux software package](https://github.com/newracom/nrc7292_sw_pkg), it is very Raspberry Pi-specific and so poorly suited for the Jetson Nano. I think that this DKMS module from Teledatics is a more idiomatic way of extending the Linux kernel.

In addition to building and applying the DKMS module, the Jetson Nano requires a few changes to interact with the NRC7292. The SPI pins need to be properly configured and available for a new kernel module to use, which is achieved in a device tree overlay called `nrc7292.dts`. Also, the number of the SPI_GPIO_IRQ should be 149 instead of 5 because of differences in the pinout between the Raspberry Pi and Jetson Nano platforms.

Another gotcha is that, because of a [bug in the bootloader](https://forums.developer.nvidia.com/t/cannot-get-spi-to-work/183855), the SPI pins cannot be used until they are properly configured by the magical command `sudo busybox devmem 0x6000d008 8 0x00`. Solely applying the device tree overlay is not enough, unfortunately.

Also, the Newracom driver includes a mechanism for synchronizing the country-coded regulatory restrictions to the NRC7292 using a "board data" file like `nrc7292_bd.dat`. A checksum failure related to this data would sometimes cause certain configurations to fail opaquely (appearing with cryptic messages in `dmesg` logs), so I disabled usage of the BD in source.