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

GRI_USB_TMP=$(exec cat /system/etc/wmt/usbconf)
if [ "$GRI_USB_TMP" = "rmadb" ]; then
rmmod g_file_storage
elif [ "$GRI_USB_TMP" = "rmfsg" ]; then
stop adbd
sleep 1
rmmod g_android
fi
echo none > /system/etc/wmt/usbconf
/system/bin/usb_call
setprop dev.wmt.usb none
