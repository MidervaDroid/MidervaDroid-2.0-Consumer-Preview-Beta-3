#!/system/bin/sh

ec()
{
  /bin/echo $* > /dev/console
}

if [ -f /data/zygote.blcr ]; then
  ec "***************load saved zygote********************"
  /system/bin/cr_restart -f /data/zygote.blcr --no-restore-pid ;
else
  ec "**************start a new zygote and checkpoint******************"
  /system/bin/app_process  $*
fi
