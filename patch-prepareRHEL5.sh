#!/bin/bash
#Patch pre-requites for RHEL patching 
#This script only applies for RHEL5
#Created on : 10-oct-2014
#USAGE : ./patch-prepareRHEL5.sh
clear;
echo " PATCH PREPARE HAS GOING TO START";
sleep 5;
uname -a ;
echo "+++++++++++++++++++++++++++++++++++++++++";
cat /etc/redhat-release ;
echo "+++++++++++++++++++++++++++++++++++++++++";
echo "atleast 2G of disk should be free in / FS";
df -h ;
echo "+++++++++++++++++++++++++++++++++++++++++";
echo "the entry should be uncommented in /etc/rpm/macros.up2date file";
grep era /etc/rpm/macros.up2date;
echo "+++++++++++++++++++++++++++++++++++++++++";
echo "tsflags=repackage <--This entry should be present in /etc/yum.conf file";
grep tsfl /etc/yum.conf ; 
echo "+++++++++++++++++++++++++++++++++++++++++";
yum repolist;
sleep 8 ;
clear;
echo "========= CLEARING THE RPM FILES FROM /var/spool/repackage  ========";
sleep 5;
cd /var/spool/repackage ;
pwd;
ls ;
echo "----------------Going to clear old packages --------------" ;
sleep 2 ;
rm -f *.rpm ;
echo "#########cleared the old packags######";
clear;
echo "===== DOWNLOADING THE NEW PACKAGES =====";
sleep 2;
rhn_check ;
yum clean all ;
yum -y install yum-downloadonly ;
yum -y update --downloadonly;
clear;
echo "======= THE PATCH PREPARE HAS BEEN COMPLETED FOR :`hostname`======";

