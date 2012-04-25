#!/bin/sh
	chmod +x /system/bin/usb_modeswitch
	chmod +x /system/bin/usb_modeswitch_loop
	chmod +x /system/etc/usb-modem-dialer
	chmod +x /system/etc/ppp/*
	chmod +x /system/etc/ppp_scripts/*
	chmod +x /system/bin/chat
	chmod +x /system/bin/chat3g
	chmod +x /system/bin/lsusb
	chmod +x /system/bin/prepare_other_3g
	mkdir -p /data/wmtpref/etc
	cp /system/etc/ppp /data/wmtpref/etc/ppp -rf
	cp /system/etc/Wireless /data/wmtpref/etc/Wireless -rf
	cp /system/bin/pppd /system/bin/ppp3g

