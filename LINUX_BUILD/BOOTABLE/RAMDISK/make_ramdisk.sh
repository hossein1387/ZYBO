#!/bin/sh
#######################################################################
#some color!
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#######################################################################

case "$1" in

	MOUNT)  echo "${green} Mounting ramdisk...${reset}"
		if [ ! -e ./ramdisk.image.gz ]; then
			echo "${red} ramdisk.image.gz does not exist!${reset}"
			exit 1
		else
			rm -rf uramdisk.image.gz
			gunzip ramdisk.image.gz
			chmod u+rwx ramdisk.image
			if [ ! -d tmp_mnt/ ]; then
				mkdir tmp_mnt/	
			fi
			sudo mount -o loop ramdisk.image tmp_mnt/
			echo "${green} image was mounted successfully! you can modify the file system... ${reset}"
		fi
	    ;;
	CREATE_RAMDISK)  echo  "${green} Creating ram disk...${reset}"
		if [ ! -e ./ramdisk.image ]; then
			echo "${red} ramdisk.image does not exist!${reset}"
			exit 1
		elif [ ! -e mkimage ]; then
			echo "${red} mkimage binary does not exist. Forgot to copy it from u-boot directory?${reset}"
			exit 1
		else
			sudo umount tmp_mnt/
			gzip ramdisk.image
			dd if=/dev/zero of=ramdisk.image bs=1024 count=8192
			mke2fs -F ramdisk.image -L "ramdisk" -b 1024 -m 0
			tune2fs ramdisk.image -i 0
			chmod a+rwx ramdisk.image
			./mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz
		fi
	    ;;
	CLEAN)
		rm -rf uramdisk.image.gz
           ;;
	*) echo "${red} ERROR! Usage: ./make_ramdisk {MOUNT}|{CREATE_RAMDISK}|{CLEAN}${reset}"
	   ;;
esac


