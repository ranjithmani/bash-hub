#!/bin/bash
#USAGE : ./monitor <no of iteration>
#EXAMPLE : ./monitor 2
#
LOG=/tmp/monitorlogs
IT=1
TT=$1
echo " collecting the performance report, please standby it takes $(($TT * 5)) seconds....."
while [ $IT -lt $TT ]
do
echo "===========================>`date`<===========================" >> $LOG
echo " Server Load :`uptime |cut -f 3  -d ,` " >> $LOG
echo " " >> $LOG
echo " CPU UTILIZATION " >> $LOG
echo "------------------------------------------------------------------------------------" >> $LOG
ps aux | head -1 >> $LOG ; ps aux |grep -v "%CPU" | sort -nr -k3 |head >> $LOG
echo " " >> $LOG
echo " MEMORY UTILIZATION " >> $LOG
echo "------------------------------------------------------------------------------------" >> $LOG
ps aux | head -1 >> $LOG ; ps aux |grep -v "%MEM" | sort -nr -k4 |head >> $LOG
echo " " >> $LOG
echo " DISK UTILIZATION" >> $LOG
echo "------------------------------------------------------------------------------------" >> $LOG
sar 1 5  |tail -7 | awk '{print $4"  "$5"  "$6"  "$6"  "$7"  "$8"  "$9}' | column -t | head -6 >> $LOG
echo "------------------------------------------------------------------------------------" >> $LOG
echo >> $LOG
iostat -x 1 5 |grep dm |sort >> $LOG
IT=$((IT + 1))
done
echo " Log collection has been completed , you can find log on "/tmp/monitorlogs" ."
exit 0
