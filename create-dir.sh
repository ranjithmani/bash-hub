#!/bin/bash
#Description : To create dirctory structure for copying the logs from the induvidual server
#USAGE       : ./create-dir.sh
#Created on  : 05-May-2015
#Dependency  : create a server.txt file in the script home directory  and add server names to which you want create directory 
# NOTE: please run this script prior to file-push.sh 
#
for i in `cat server.txt`
do 
cd /archive 
if [ ! -d $i ]
then 
mkdir $i
fi
cd $i
CY=`date | awk '{print $6}'`
if [ ! -d $CY ]
then 
mkdir $CY
fi
cd $CY
CM=`date | awk '{print $2}'`
if [ ! -d $CM ]
then
mkdir $CM
fi
cd $CM
CD=`date +%D | awk -F /  '{print $1}'`
if [ ! -d $CD ]
then
mkdir $CD
fi

done
