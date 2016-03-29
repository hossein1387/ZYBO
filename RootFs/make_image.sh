#!/bin/bash
CURRENT_PWD=pwd
case "$1" in
	-h|--help)
		echo "sh| make_image.sh -h| -pack file_system_directory image_file | -unpack zipped_file_system mount_point "	
	;;
	-unpack)
		echo "mounting file system:"
		Z_FILE_SYSTEM=$2
		MNT_DIRECTORY=$3
		if [ ! -f "$Z_FILE_SYSTEM" ]; then
		    echo "$Z_FILE_SYSTEM file system does not exist! "
		    exit
		fi
		gunzip $Z_FILE_SYSTEM
		parts=(${Z_FILE_SYSTEM//.gz/ })
		chmod u+rwx ${parts[0]} 
		mount -o loop ${parts[0]} $MNT_DIRECTORY			
	;;
	-pack)
		DIRECTORY=$2
		FILE_SYSTEM_IMAGE=$3
		echo "making image:"
		rm -rf uramdisk.image.gz
		if [ ! -d "$DIRECTORY" ]; then
		    echo "$DIRECTORY directory does not exist! "
		    exit
		fi
		if [ ! -f "$FILE_SYSTEM_IMAGE" ]; then
		    echo "$FILE_SYSTEM_IMAGE file system image does not exist! "
		    exit
		fi		
		if mount | grep $DIRECTORY > /dev/null; then
			echo " unmounting $DIRECTORY"
			sudo umount $DIRECTORY 
		fi
		gzip $FILE_SYSTEM_IMAGE	
		mkimage -A arm -T ramdisk -C gzip -d $FILE_SYSTEM_IMAGE.gz uramdisk.image.gz
		mv ./uramdisk.image.gz /media/sf_SHARED_FOLDER/ 		
	;;
        *)
		echo "sh| make_image.sh -h| -pack file_system_directory image_file | -unpack zipped_file_system mount_point "	
        ;;
esac
