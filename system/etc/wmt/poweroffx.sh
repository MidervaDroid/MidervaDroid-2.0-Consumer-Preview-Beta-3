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

/bin/umount /LocalDisk
if [ $? -ne 0 ];then
#call WmtService::poweroff function, it will umount /LocalDisk and /sdcard internally.
	service call wmt.server 100
else
	/bin/umount /sdcard
fi


root_dev=`wmtenv get rootdev`
if [ "$root_dev" == "NAND" ] || [ "$root_dev" == "" ]; then
	echo "[WMT] poweroff, root device is Nand"
	losetup -d /dev/block/loop0
	/bin/umount /mnt/localdisk
	reboot -p &
	sleep 8
elif [ "$root_dev" == "TF" ]; then
	echo "[WMT] poweroff, root device is TF"
else
	echo "[WMT] poweroff, unknown root device"
fi

while [ 2 -ge 1 ]                                                               
do                                                                              
        #do it forever                                                          
        mu s 0xd8130010 0x00050000                                              
        sleep 1                                                                 
done      
