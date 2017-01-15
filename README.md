
# What is this?

This repository contains my Linux builds and projects for ZYBO Zynq dev board. It also provides steps to manually boot linux on the ARM host of the ZYNQ. **This is a custom build of linux for zynq with minimal utils. Maybe a better soloution for you is to use [PetaLinux](http://www.wiki.xilinx.com/PetaLinux)?** 

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

## Modifing FileSystem:
Although I am still using this method, but it is very tidious nad time consuming. I do not recommend this method at all.
The script for automating this process is available in this repository at [RootFs](https://github.com/hossein1387/ZYBO/tree/master/RootFs).

1- First need to download the arm root file system from [http://www.wiki.xilinx.com/Build+and+Modify+a+Rootfs](http://www.wiki.xilinx.com/Build+and+Modify+a+Rootfs). You can use a copy of arm_ramdisk.image.gz if you have it localy available.

2- Unzip the file by typing:

	gunzip arm_ramdisk.image.gz

3- Make sure the unzipped file has the proper permission for user root:

	chmod u+rwx arm_ramdisk.image

4- Mount the ramdisk to local drive (assuming the tmp_mnt is already created):

    sudo mount -o loop arm_ramdisk.image tmp_mnt/

5- Make changes in the file system an unmount and zip the temporary folder:
  
	sudo umount tmp_mnt/ & gzip arm_ramdisk.image

6- The image needs to be wrapped around u-boot headers, for that use mkimage utility (if you don't have it: apt-get install u-boot-tools):

	mkimage -A arm -T ramdisk -C gzip -d arm_ramdisk.image.gz uramdisk.image.gz

7- Do neccessary cleanups:

	rm -rf tmp_mnt

Now that the filesystem is ready you can save it on an SD card. These steps are automated by make_image.sh script in [RootFs](https://github.com/hossein1387/ZYBO/tree/master/RootFs) repository. 


## Copyright

Copyright (c) 2016 [hossein1387](http://hossein1387.github.io/).

## Useful repos and resources:

http://www.googoolia.com/wp/

https://github.com/ucb-bar/fpga-zynq




