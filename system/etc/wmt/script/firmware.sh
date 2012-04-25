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
#
# Firmware-specific hotplug policy agent.
#
# Kernel firmware hotplug params include:
#
#       ACTION=%s [add or remove]
#       DEVPATH=%s [in 2.5 kernels, /sys/$DEVPATH]
#       FIRMWARE=%s
#
# HISTORY:
#
# This script file was modified from the file "/etc/hotplug/firmware.agent"
#

# DEBUG=yes export DEBUG

# directories with the firmware files
FIRMWARE_DIRS="/lib/firmware /usr/local/lib/firmware /usr/lib/hotplug/firmware"

# mountpoint of sysfs
SYSFS=$(sed -n '/^.* \([^ ]*\) sysfs .*$/ { s//\1/p ; q }' /proc/mounts)

# use /proc for 2.4 kernels
if [ "$SYSFS" = "" ]; then
    SYSFS=/proc
fi

#
# What to do with this firmware hotplug event?
#
case "$ACTION" in

add)
    counter=5
    while [ ! -e $SYSFS/$DEVPATH/loading -a $counter -gt 0 ]; do
        sleep 1
	counter=$(($counter - 1))
    done

    if [ $counter -eq 0 ]; then
	mesg "$SYSFS/$DEVPATH/ does not exist"
	exit 1
    fi

    for DIR in $FIRMWARE_DIRS; do
        [ -e "$DIR/$FIRMWARE" ] || continue
        echo 1 > $SYSFS/$DEVPATH/loading
        cat "$DIR/$FIRMWARE" > $SYSFS/$DEVPATH/data
        echo 0 > $SYSFS/$DEVPATH/loading
        exit
    done

    # the firmware was not found
    echo -1 > $SYSFS/$DEVPATH/loading

    ;;

remove)
    ;;

*)
    mesg "Firmware '$ACTION' event not supported"
    exit 1
    ;;

esac
