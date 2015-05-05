#!/bin/bash
#Description : To push the log files to a central server
#USAGE       : ./file-push.sh
#Created on  : 5-May-2015
#Dependency  : none
#
CY=`date | awk '{print $6}'`
CM=`date | awk '{print $2}'`
CD=`date +%D | awk -F /  '{print $1}'`
HOST=`hostname` # make sure this hostname and directory in archive folder are in match 
#please change the name or ip of your central server
DEST=192.168.122.4
LOG=/home/loguser/filetransferlog
#change your file transferlog location as per your wish
cd /var/log
echo "=======> file copying starting @ `date` <========" >>$LOG
rsync -avz -e ssh messages*.gz loguser@$DEST:/archive/$HOST/$CY/$CM/$CD/ >>$LOG
rsync -avz -e ssh secure*.gz loguser@$DEST:/archive/$HOST/$CY/$CM/$CD/ >>$LOG
#if you want to add additional logs to transfer please add here
echo "=======> file copying completed @ `date` <========" >>$LOG
exit 0
