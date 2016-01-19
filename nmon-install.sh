#!/bin/bash
LOG=/root/nmon.log
#USAGE : ./nmon-install.sh
#Description : To install and configure nmon on RHEL 5 and 6 
#Created BY : Ranjith Mani
#Created ON : 19-Jan-2016
#
function check()
{
if [ $(uname -r|awk -F "-" '{print $1}') == 2.6.32 ]
then
echo "you are running RHEL/CENTOS/OEL 6"
echo "$(date +%D"-"%T):OS version verified." >>$LOG
precheck
install
cron
sleep 1
echo "Nmon installation and configuration has been completed."
echo "you can found the installation logs in /root/nmon.log"
elif [ $(uname -r|awk -F "-" '{print $1}') == 2.6.18 ]
then
echo "you are running RHEL/CENTOS/OEL 5"
echo "$(date +%D"-"%T):OS version verified." >>$LOG
precheck
install5
cron
sleep 1
echo "Nmon installation and configuration has been completed."
elif [ $(uname -r|awk -F "-" '{print $1}') == 3.10.0 ]
then
clear
echo "It seems you are running RHEL/CENTOS 7 , Nmon not supported for this Version of OS"
else
echo "Unable to guess the OS...!!!"
fi
}
function install()
{
sleep 1
echo "installing nmon package .."
rpm -ivh nmon-14g-1.el6.rf.x86_64.rpm >> $LOG 2>&1
echo "$(date +%D"-"%T):Nmon installation completed." >>$LOG
sleep 1
echo "nmon package has been installed ."
echo "copying the nmon script to /opt/scripts"
cp -f nmon.sh /opt/scripts/
echo "$(date +%D"-"%T):Nmon script has been copied.." >>$LOG
sleep 1
echo  "changing the necesasry permissions to nmon script"
chmod a+x /opt/scripts/nmon.sh
}
function install5()
{
sleep 1
echo "installing nmon package .."
rpm -ivh nmon-14g-1.el5.rf.x86_64.rpm >>$LOG 2>&1
echo "$(date +%D"-"%T):Nmon installation completed." >>$LOG
sleep 1
echo "nmon package has been installed ."
echo "copying the nmon script to /opt/scripts"
cp -f nmon.sh /opt/scripts/
echo "$(date +%D"-"%T):Nmon script has been copied.." >>$LOG
sleep 1
echo  "changing the necesasry permissions to nmon script"
chmod a+x /opt/scripts/nmon.sh
}

function cron()
{
echo "############# Nmon cron ############" >> /var/spool/cron/root
echo "00  00 * * * /opt/scripts/nmon.sh " >> /var/spool/cron/root
echo "$(date +%D"-"%T):CRON entry added for Nmon." >>$LOG
}
function precheck()
{
sleep 2
echo "creating /var/log/nmon_reports directory"
test -d /var/log/nmon_reports || mkdir -p /var/log/nmon_reports
sleep 2
echo "creating /opt/scripts directory"
test -d /opt/scripts || mkdir -p /opt/scripts
echo "$(date +%D"-"%T):Nmon precheck has been completed." >>$LOG
}
check
