#!/bin/bash
#
#Description : To take LVM  backup of any file system and dup it to a NFS/Remote FS
#Author : Ranjith Mani
#Created on : 5-Aug-2016
#
####### Set the below values as per your Env.######
SNAP_SIZE=1G
SNAP_LV=lv_root
SNAP_VG=vg_master
SNAP_MNT_DIR=/rootsnap
SNAP_NAME=rootsnap
NFS_DIR=/mnt
LOG=/root/snapbackup.log
##################################################
#              EXIT STATUS CODES
#              =================
#        1 = You are not root
#        2 = Snapshots are already available 
#        3 = Unable to create snapshot
#        4 = Unable to mount the snapshot
#        5 = NFS/Destination storage not mounted 
#        6 = tar backup got failed
#        7 = Unable to remove snapshot
#################################################
#
#
if [ `id -u` != 0 ]
   then
   echo "You are not root!!!!. Exiting"
   exit 1
fi
lvs |awk '{print $3}'|grep ^s > /dev/null 2>&1
if [ $? == 0 ]
   then
   echo "snapshots are available , remove snapshot manually and run again."
   exit 2
fi
echo " " >> $LOG 2>&1
echo " " >> $LOG 2>&1
echo "`date +%d"-"%h"-"%Y`:Starting the Backup">> $LOG 2>&1
echo "Taking snapshot of $SNAP_LV" >> $LOG 2>&1
lvcreate -s -L $SNAP_SIZE -n $SNAP_NAME /dev/$SNAP_VG/$SNAP_LV  >>$LOG 2>&1
if [ $? == 0 ]
   then
   echo "snapshot of \"$SNAP_LV\" has been successfully taken" >> $LOG
   echo "snapshot of \"$SNAP_LV\" has been successfully taken"
   else
   echo "snapshot of \"$SNAP_LV\" has been Failed !!!, Please check the logs"  >> $LOG
   echo "snapshot of \"$SNAP_LV\" has been Failed !!!, Please check the logs"
   exit 3
fi
test -d $SNAP_MNT_DIR || mkdir -p $SNAP_MNT_DIR
mount /dev/$SNAP_VG/$SNAP_NAME $SNAP_MNT_DIR  >> $LOG 2>&1
if [ $? == 0 ]
   then
   echo "snapshot volume \"$SNAP_NAME\" has been mounted on $SNAP_MNT_DIR"  >> $LOG
   echo "snapshot volume \"$SNAP_NAME\" has been mounted on $SNAP_MNT_DIR"
   else
   echo "snapshot mounting failed, Please check the logs"  >> $LOG
   echo "snapshot mounting failed, Please check the logs"
   exit 4
fi
df -h |grep -w $NFS_DIR >> $LOG 2>&1
if [ $? != 0 ]
   then
   echo "$NFS_DIR not mounted, Please check the logs"  >> $LOG
   echo "$NFS_DIR not mounted, Please check the logs"
   umount $SNAP_MNT_DIR
   lvremove /dev/$SNAP_VG/$SNAP_NAME -f >> $LOG 2>&1
   rm -rf $SNAP_MNT_DIR
   exit 5
fi
test -d  $NFS_DIR/`hostname`/rootsnapbkp_`date +%d"-"%h"-"%Y` || mkdir -p $NFS_DIR/`hostname`/rootsnapbkp_`date +%d"-"%h"-"%Y`
cd $NFS_DIR/`hostname`/rootsnapbkp_`date +%d"-"%h"-"%Y`
echo "Starting the snapshot backup , please wait" >>  $LOG
echo "Starting the snapshot backup , please wait"
tar -pzcf root_backup.tar.gz $SNAP_MNT_DIR  > /dev/null 2>&1
if [ $? == 0 ]
   then
   echo "snapshot backup completed successfully."  >> $LOG
   echo "snapshot backup completed successfully." 
   else
   echo "snapshot backup Failed , please check the logs"  >> $LOG
   echo "snapshot backup Failed , please check the logs"
   exit 6
fi
cd
echo "Removing the snapshot"  >> $LOG 2>&1
umount $SNAP_MNT_DIR
lvremove /dev/$SNAP_VG/$SNAP_NAME -f >> $LOG 2>&1
rm -rf $SNAP_MNT_DIR
if [ $? == 0 ]
   then
   echo "snapshot /dev/$SNAP_VG/$SNAP_NAME removed." >> $LOG
   cho "snapshot /dev/$SNAP_VG/$SNAP_NAME removed."
   else
   echo "snapshot removal faild , please check logs" >> $LOG
   echo "snapshot removal faild , please check logs"
   exit 7
fi
