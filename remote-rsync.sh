#!/bin/bash
# RSYNC SCRIPT TO SYNC  FILESYSTEM BETWEEN SERVER1 and SERVER2
# variables
SOURCE_PATH='/SRC/'
SOURCE_SERVER='SERVER1'
DESTINATION_PATH='/DEST/'
DESTINATION_HOST='SERVER2'
DESTINATION_USER='root'
LOGFILE='/var/log/dir_sync_log'
#copying the files
echo $'\n\n' >> $LOGFILE
/usr/bin/rsync -arvA --rsh=ssh $SOURCE_PATH $DESTINATION_USER@$DESTINATION_HOST:$DESTINATION_PATH 2>&1 >> $LOGFILE
echo "Sync Completed at:`/bin/date`" >> $LOGFILE
