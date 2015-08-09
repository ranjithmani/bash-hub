#!/bin/bash
#
#script to take backup , rotate and  transfer it.
#pre-requsites:
#1 . a user gsmc in the booth servers and passwordless auth enabled
#2 . utilities like bc, rsync 
#USAGE: ./managebkp.sh backup , ./managebkp.sh copy , ./managebkp.sh rotate
#Created By :Ranjith Mani
#Created Date:6-August-2015

backup()
{
touch /tmp/managebackuplog
chmod 666 /tmp/managebackuplog
LOG=/tmp/managebackuplog
echo "========================>`date`<===========================" >> $LOG
echo "starting the backup........." >> $LOG
mkdir -p /root/backup/$(hostname).$(date +%d-%m-%y)
BAK=/root/backup/$(hostname).$(date +%d-%m-%y)
echo "backing up files /etc " >> $LOG
tar -zcvf $BAK/etc_bak.tar.gz /etc > /dev/null
echo "backing up files /home/export " >> $LOG
tar -zcvf $BAK/home-export_bak.tar.gz /home/export > /dev/null
echo "backing up files /opt/gsmc " >> $LOG
tar -zcvf $BAK/opt_gsmc.tar.gz /opt/gsmc > /dev/null
echo "backing up all cron entries  " >> $LOG
tar -zcvf $BAK/cron_back.tar.gz /var/spool/cron > /dev/null
cd /root/Backup
cp `ls -r /root/Backup/ | tail -1` $BAK/
echo "OS_config backup has been moved" >> $LOG
tar -zcvf backup-$(date +%d-%m-%y).tar.gz $BAK > /dev/null
chmod 555 backup-$(date +%d-%m-%y).tar.gz
mv backup-$(date +%d-%m-%y).tar.gz /home/gsmc/ > /dev/null
rm -rf $BAK/
echo "Backup has been completed....." >> $LOG
exit 0
}

#filetransferring starts here
copy()
{
LOG=/tmp/managebackuplog
echo "========================>`date`<===========================" >> $LOG
SRC=/home/gsmc
DST=/home/gsmc/backup
cd $SRC
rsync -avz -e ssh backup-* gsmc@192.168.1.1:$DST >>$LOG
if [ $? -eq 0 ]
then
echo "file copy has completed , removing the file " >>$LOG
rm -vf backup-* >>$LOG
else
echo "file copy didn't completed , please check the logs" >>$LOG
fi
exit 0
}

#logrotate starts here
rotate()
{
LOG=/tmp/managebackuplog
echo "========================>`date`<===========================" >> $LOG
cd /home/gsmc/backup
R=$(ls -lrt backup-* |wc -l)
if [ $R -gt 7 ]
then
B=$(echo "$R - 7"|bc)
ls -rt | head -$B > rem
for i in `cat rem`
do
{
rm -vf $i >>$LOG
}
done
rm -f rem
echo "removed $B files " >>$LOG
else
echo " No files to rotate" >>$LOG
fi
exit 0
}

case "$1" in

        backup)
                backup
                ;;
        copy)
                copy
                ;;
        rotate)
                rotate
                ;;
        *)
        echo "Usage: managebkp.sh {backup|rotate|copy}"
        esac
        exit 0
