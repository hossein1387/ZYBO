
# What is this?

This repository contains my Linux builds and projects for ZYBO Zynq dev board. It also provides steps to manually boot linux on the 
ARM host of the ZYNQ.

## Booting Manually:

Files for manual boot is available in this repo at [LINUX_BUILD/BOOTABLE/BARE_MIN/](https://github.com/hossein1387/ZYBO/tree/master/LINUX_BUILD/BOOTABLE/BARE_MIN/).
To manually boot linux, you need to setup your environment to use Xilinx tools, specially XMD. For that you can use:

    source /PATH/TO/XILINX/INSTALLATION/settings64.sh

Then plug-in your ZYBO board using the USB-Jtag connector. Now type xmd and then:

    run: xmd:
 	 xmd> conenct arm hw
	 xmd> source ps7_init.tcl 
	 xmd> ps7_init
	 xmd> dow u-boot.elf  // neccessary for jtag-usb to come up correctly
	 xmd> run
	 xmd> stop
 	 xmd> dow -data uramdisk.image.gz 0x10000000
	 xmd> dow -data uImage 0x13200000          
	 xmd> dow -data zynq-zybo.dtb 0x16400000 
         xmd> run

on another console, connect to board using jtag-usb:

	 hossein> sudo picocom -b 115200 /dev/ttyUSB1:		
	 => bootm 0x13200000 0x10000000 0x16400000

<img src="https://github.com/hossein1387/ZYBO/blob/master/images/lunxh.png" width="700" />

## Copyright

Copyright (c) 2016 [hossein1387](http://hossein1387.github.io/).

## Useful repos and resources:

http://www.googoolia.com/wp/
https://github.com/ucb-bar/fpga-zynq




