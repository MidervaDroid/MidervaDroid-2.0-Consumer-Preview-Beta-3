#!/bin/sh
#
# Add-ons for creating the backfile.vfat
#

printf "\nFormat backfile...\n"


# get_mtd_len - get mtd length by name
# @name
get_mtd_len ()
{
	tmp=`cat /proc/mtd |grep "$1"|cut -d\  -f 2`
	len=`printf "0x%x" 0x$tmp`
	echo $len
}


# format_backfile () - format the big file backfile.vfat
#
backfile=/mnt/localdisk/backfile.vfat
loopdev=/dev/block/loop0
mount_point=/LocalDisk
root_dev=`wmtenv get rootdev`
localdisk_size=`get_mtd_len "LocalDisk"`
max_size=8589934592 

format_backfile ()
{
        if [ "$root_dev" == "NAND" ] || [ "$root_dev" == "" ]; then
                mkdosfs $backfile
                /sbin/losetup $loopdev $backfile
                /bin/mount -t vfat -o utf8 $loopdev $mount_point
        elif [ "$root_dev" == "TF" ]; then
                mkdosfs /dev/block/mmc1blk0p7
                /bin/mount -t vfat -o utf8 /dev/block/mmc1blk0p7 $mount_point
        else
                echo "[WMT] Format LocalDisk, unknown root device"
        fi
        setprop ctl.start wmtserver
}

# Create back file
#
create_backfile ()
{
        if [ "$root_dev" == "NAND" ] || [ "$root_dev" == "" ]; then		
        	if [ $((localdisk_size)) -gt $((max_size))  ]; then	
        		/system/bin/flash_eraseall  /dev/mtd/mtd16
        		mount -t yaffs2 -o rw /dev/block/mtdblock16 /LocalDisk/
			chmod 777 /LocalDisk
		        setprop ctl.start wmtserver
			sync
        		return 0	
        	fi		
        	
        	if [ -f $backfile ];then
			rm $backfile -rf
		fi
		mtd_max=2147483648
		mtd_len=`get_mtd_len "LocalDisk"`
		if [ "$(($mtd_max))" -lt "$(($mtd_len))" ]; then
			mtd_len=$(($mtd_max))
		fi
		mtd_lendec=`echo $(($mtd_len))`
		mtd_full_reserve=$(( $mtd_lendec + 1073741824 ))
		mtd_full_reserve=$(( $mtd_full_reserve * 5 ))
		mtd_full_reserve=$(( $mtd_full_reserve / 100 ))
		mtd_small_reserve=$(( $mtd_lendec * 5 ))
		mtd_small_reserve=$(( $mtd_small_reserve / 100 ))
		mtd_reserve=$(( $mtd_lendec - $mtd_full_reserve ))	
		mtd_min=10485760
		if [ "$(($mtd_reserve))" -le "$(($mtd_min))" ]; then
			mtd_lendec=$(( $mtd_lendec - $mtd_small_reserve ))
		else
			mtd_lendec=$(( $mtd_lendec - $mtd_full_reserve ))
		fi
		echo "[WMT] Creating UDC udc_file...\n"
		/bin/dd if=/dev/zero of=$backfile bs=1 seek=$mtd_lendec count=1
		/sbin/mkdosfs $backfile	
                /sbin/losetup $loopdev $backfile
                /bin/mount -t vfat -o utf8 -o sync $loopdev $mount_point
        elif [ "$root_dev" == "TF" ]; then
                mkdosfs /dev/block/mmc1blk0p7
                /bin/mount -t vfat -o utf8 /dev/block/mmc1blk0p7 $mount_point
        else
                echo "[WMT] Format LocalDisk, unknown root device"
        fi
        setprop ctl.start wmtserver
	sync
}


# prepare_for_format () - Just preparation
#
prepare_for_format ()
{
        if [ "$root_dev" == "NAND" ] || [ "$root_dev" == "" ]; then
		if [ $((localdisk_size)) -gt $((max_size))  ]; then	
			service call wmt.server 101
			setprop ctl.stop wmtserver
			return 0
		fi

                if [ ! -f $backfile ];then
                        printf "$backfile not exist.\n"
			return 1
                fi
               # setprop ctl.stop wmtserver
               # if [ $? -ne 0 ]; then
               #         return 1
               # fi
               #  /bin/umount $mount_point
               # if [ $? -ne 0 ]; then
               #         printf "umount failed.\n"
               #         /bin/mount -t vfat -o utf8 $loopdev $mount_point
               #         setprop ctl.start wmtserver
               #         return 2
               # fi
		service call wmt.server 101
		setprop ctl.stop wmtserver
                /sbin/losetup -d $loopdev
                if [ $? -ne 0 ]; then
                        /bin/mount -t vfat -o utf8 $loopdev $mount_point
                        setprop ctl.start wmtserver
                        return 3
                fi
        elif [ "$root_dev" == "TF" ]; then
                setprop ctl.stop wmtserver
                if [ $? -ne 0 ]; then
                        return 1
                fi
                /bin/umount -lf $mount_point
                if [ $? -ne 0 ]; then
                        printf "umount failed.\n"
                        /bin/mount -t vfat -o utf8 $loopdev $mount_point
                        setprop ctl.start wmtserver
                        return 2
                fi
        else
                echo "[WMT] Format LocalDisk, unknown root device"
        fi
        return 0
}

prepare_for_format
res=$?
if [ $res -ne 0 ]; then
        echo "res = $res"
        printf "\nFormat backfile failed!\n"
        return $res
fi
#format_backfile
create_backfile
printf "\nFormat backfile done.\n"
return 0

