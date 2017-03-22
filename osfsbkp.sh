#!/bin/bash
#
#DESCRIPTION: To take backup of root and boot xfs file systems
#Dependency : xfsdump and nfs-utils package should be installed.
#Please configure the backup attributes first and run.
#Created by : Ranjith Mani
#Created On : 15 - Mar - 2017
#
### PLEASE CONFIGURE BELOW ATTRIBUTES ###
NFS_SERVER_IP=
NFS_SERVER_SHARE=
NFS_MNT_DIR=/nfs_bkp
BKP_DATE=$(date +%d"-"%m"-"%Y)
BKP_HOST=$(uname -n)
#root volume name
BKP_VOLUME1="/dev/ol/root"
#boot volume name
BKP_VOLUME2="/dev/xvda1"
### CONFIGURATION ENDS HERE ###
#
#
#create the nfs mount directory
test -d $NFS_MNT_DIR || mkdir $NFS_MNT_DIR
# mount the nfs volumes
mount.nfs $NFS_SERVER_IP:$NFS_SERVER_SHARE $NFS_MNT_DIR
if [ $? == 0 ]
then
echo "NFS share mounted to $NFS_MNT_DIR"
else
echo "NFS mounting  failed...!!!"
exit 1
fi
#
echo -e "This backup session is about to take backup of below volumes\n$BKP_VOLUME1\n$BKP_VOLUME2"
echo -n "Is this Ok to go ahead ? [yes|no]:"
read ch
if [ $ch == "yes" ]
then
test -d $NFS_MNT_DIR/`hostname` || mkdir -p $NFS_MNT_DIR/`hostname`
echo "Initiating backup process"
for j in 1 2
do
if [ $j == 1 ]
then
BKP_NAME=root
xfsdump -F -f $NFS_MNT_DIR/`hostname`/`hostname`_`date +%d"-"%m"-"%Y`.$BKP_NAME.dump $BKP_VOLUME1
elif [ $j == 2 ]
then
BKP_NAME=boot
xfsdump -F -f $NFS_MNT_DIR/`hostname`/`hostname`_`date +%d"-"%m"-"%Y`.$BKP_NAME.dump $BKP_VOLUME2
fi
echo "$BKP_NAME backup has been completed .....!!!!!"
sleep 5
done
else
echo "Aborting the backup"
umount $NFS_MNT_DIR
if [ $? == 0 ]
then
echo "NFS share unmounted ...!!!"
exit 0
else
echo "NFS unmounting  failed...!!!"
exit 2
fi
fi
#unmount nfs directory
sync;sync;sync
umount $NFS_MNT_DIR
if [ $? == 0 ]
then
echo "NFS share unmounted ...!!!"
exit 0
else
echo "NFS unmounting  failed...!!!"
exit 2
fi
