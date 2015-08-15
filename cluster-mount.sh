#!/bin/bash
#Custome script for mount redhat cluster unsupported file systems 
#call the script with in a service group as a script .
#Created By : Ranjith Mani
#Created On : 16-Aug-2015
start()
{
mount -t iso9660 -o ro /dev/sr0 /var/lib/tftpboot/centos6_x86_64 && mount -t iso9660 -o ro /dev/sr1 /var/lib/tftpboot/rhel6_x86_64
if [ $? == 0 ]
then
echo > /var/run/mntd.pid
exit 0
RETVAL 0
else
exit 1
fi
}
stop()
{
umount /dev/sr0 && umount /dev/sr1
rm -f /var/run/mntd.pid
}
status()
{
test -f /var/run/mntd.pid && echo " MNTD service is running " || exit 1
}
case "$1" in
  start)
  start
  ;;
  stop)
  stop
  ;;
  restart)
  stop
  start
  ;;
  status)
  status
  ;;
  *)
  echo $"Usage: $0 {start|stop|restart|status}"
  esac
