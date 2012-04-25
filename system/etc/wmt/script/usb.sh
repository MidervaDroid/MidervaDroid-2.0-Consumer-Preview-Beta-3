#!/bin/sh
################################################################################
#                                                                              #
# Copyright c 2009  WonderMedia Technologies, Inc.   All Rights Reserved.      #
#                                                                              #
# This PROPRIETARY SOFTWARE is the property of WonderMedia Technologies, Inc.  #
# and may contain trade secrets and/or other confidential information of       #
# WonderMedia Technologies, Inc. This file shall not be disclosed to any third #
# party, in whole or in part, without prior written consent of WonderMedia.    #
#                                                                              #
# THIS PROPRIETARY SOFTWARE AND ANY RELATED DOCUMENTATION ARE PROVIDED AS IS,  #
# WITH ALL FAULTS, AND WITHOUT WARRANTY OF ANY KIND EITHER EXPRESS OR IMPLIED, #
# AND WonderMedia TECHNOLOGIES, INC. DISCLAIMS ALL EXPRESS OR IMPLIED          #
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET       #
# ENJOYMENT OR NON-INFRINGEMENT.                                               #
#                                                                              #
################################################################################

if [ "$1" = "mount" ]; then
GRI_USB_TMP=$(exec cat /system/etc/wmt/mount_conf)
if [ "$GRI_USB_TMP" = "umount" ]; then
echo mount > /system/etc/wmt/mount_conf
elif [ "$GRI_USB_TMP" = "" ]; then
echo mount > /system/etc/wmt/mount_conf
fi
fi

if [ "$1" = "umount" ]; then
GRI_USB_TMP=$(exec cat /system/etc/wmt/mount_conf)
if [ "$GRI_USB_TMP" = "mount" ]; then
echo umount > /system/etc/wmt/mount_conf
elif [ "$GRI_USB_TMP" = "" ]; then
echo umount > /system/etc/wmt/mount_conf
fi
fi

if [ "$1" = "reinsmod" ]; then
echo reinsmod > /reinsmod.tmp
rmmod g_file_storage
root_dev=`wmtenv get rootdev`
sleep 1
if [ "$root_dev" == "NAND" ] || [ "$root_dev" == "" ]; then
modprobe g_file_storage file=/dev/block/loop0,/dev/block/mmcblk0 removable=1 stall=0 file1=/dev/block/loop0,/dev/block/mmcblk1
elif [ "$root_dev" == "TF" ]; then
modprobe g_file_storage file=/dev/block/mmc1blk0p7,/dev/block/mmcblk0 removable=1 stall=0 file1=/dev/block/mmc1blk0p7,/dev/block/mmcblk1
else
	echo "[WMT] g_file_storage, unknown root device"
fi
fi