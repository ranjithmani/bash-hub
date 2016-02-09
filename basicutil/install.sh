#!/bin/bash
# * To install and configure nmon and cfg2html utilities 
# * copy nmon and cfg2html binaries to the directory and execute ./install.sh
# Created By : Ranjith Mani
# Created On : 9-Feb-2016
LOG=/root/nmon.log
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
echo "Nmon & cfg2html installation and configuration has been completed."
echo "you can found the installation logs in /root/nmon.log"
elif [ $(uname -r|awk -F "-" '{print $1}') == 2.6.18 ]
then
echo "you are running RHEL/CENTOS/OEL 5"
echo "$(date +%D"-"%T):OS version verified." >>$LOG
precheck
install5
cron
sleep 1
echo "Nmon & cfg2html installation and configuration has been completed."
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
echo "copying the nmon script to /opt/snxt/scripts"
cp -f nmon.sh /opt/snxt/scripts/
echo "$(date +%D"-"%T):Nmon script has been copied.." >>$LOG
sleep 1
echo  "changing the necesasry permissions to nmon script" 
chmod a+x /opt/snxt/scripts/nmon.sh
echo "installing cfg2html....."
rpm -ivh cfg2html-linux-2.99-1.noarch.rpm >> $LOG 2>&1
echo "cfg2html package installed." >> $LOG 2>&1
sleep 1
echo "cfg2html package installed."
cp -f cfg2bkp /opt/snxt/scripts/
chmod a+x /opt/snxt/scripts/cfg2bkp
echo "cfg2html script installed."
cp -f cfgrotate /opt/snxt/scripts/
chmod a+x /opt/snxt/scripts/cfgrotate
echo "cfg2html rotate script installed."

}
function install5()
{
sleep 1
echo "installing nmon package .."
rpm -ivh nmon-14g-1.el5.rf.x86_64.rpm >>$LOG 2>&1
echo "$(date +%D"-"%T):Nmon installation completed." >>$LOG
sleep 1
echo "nmon package has been installed ."
echo "copying the nmon script to /opt/snxt/scripts"
cp -f nmon.sh /opt/snxt/scripts/
echo "$(date +%D"-"%T):Nmon script has been copied.." >>$LOG
sleep 1
echo "changing the necesasry permissions to nmon script"
chmod a+x /opt/snxt/scripts/nmon.sh
echo "installing cfg2html....."
rpm -ivh cfg2html-linux-2.99-1.noarch.rpm >> $LOG 2>&1
echo "cfg2html package installed." $LOG 2>&1
sleep 1
echo "cfg2html package installed."
cp -f cfg2bkp /opt/snxt/scripts/
chmod a+x /opt/snxt/scripts/cfg2bkp
echo "cfg2html script installed."
cp -f cfgrotate /opt/snxt/scripts/
chmod a+x /opt/snxt/scripts/cfgrotate
echo "cfg2html rotate script installed."
}

function cron()
{
echo "############# Nmon cron ############" >> /var/spool/cron/root
echo "00  00 * * * /opt/snxt/scripts/nmon.sh " >> /var/spool/cron/root
echo >> /var/spool/cron/root
echo "$(date +%D"-"%T):CRON entry added for Nmon." >>$LOG
echo "Nmon cron installed."
echo "############# cfg2html cron ############" >> /var/spool/cron/root
echo "50  23 * * * /opt/snxt/scripts/cfg2bkp " >> /var/spool/cron/root
echo "$(date +%D"-"%T):CRON entry added for cfg2html." >>$LOG
echo "Cfg2html cron installed"
echo "15  00 * * * /opt/snxt/scripts/cfgrotate " >> /var/spool/cron/root
echo "Cfg2html rotate cron installed"
}
function precheck()
{
sleep 2
echo "creating /var/log/nmon_reports directory"
test -d /var/log/nmon_reports || mkdir -p /var/log/nmon_reports
sleep 2
echo "creating /var/log/cfg2html directory"
test -d /var/log/cfg2html || mkdir -p /var/log/cfg2html
sleep 2

echo "creating /opt/snxt/scripts directory"
test -d /opt/snxt/scripts || mkdir -p /opt/snxt/scripts
echo "$(date +%D"-"%T):Nmon precheck has been completed." >>$LOG
}
function post_check()
{
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bash_profile
echo "$(date +%D"-"%T):History time format enabled." >>$LOG
}
check
post_check
