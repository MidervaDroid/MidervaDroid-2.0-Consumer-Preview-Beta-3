#!/system/bin/sh
if [ $* -eq 0 ]; then
/system/bin/powerxgmodem 0
elif [ $* -eq 1 ]; then
/system/bin/powerxgmodem 1
else
/system/bin/powerxgmodem 0
sleep 3
/system/bin/powerxgmodem 1
fi