#!/bin/bash
#Simple script to collect the user information from server
#It will give the below details:
# * Normal user list , usually more than 500 UID 
# * User Last login detals
# * User status , active or locked 
# * Whether the user is available in sudo list 
# USAGE : ./usercollect.sh
#
awk -F: '{if ($3 >= 500) { print $1 } }' /etc/passwd > user.txt
UTOT=`cat user.txt |wc -l`
echo " Collecting user details in `hostname` .........."
sleep 2
for i in `cat user.txt`
do
echo "==================> User Report for $i ===========================" >> /tmp/userreport.txt
echo "Username : $i" >> /tmp/userreport.txt
ID=`grep  $i /etc/passwd | cut -f 3 -d : `
echo "User ID  : $ID" >> /tmp/userreport.txt
ULAST=`last $i | head -1`
echo " Last login : $ULAST " >> /tmp/userreport.txt
USTAT=`passwd -S $i`
echo " User Status :$USTAT " >> /tmp/userreport.txt
USUD=`grep $i /etc/sudoers`
echo " Sudo status : $USUD " >> /tmp/userreport.txt
echo "========================================================================" >> /tmp/userreport.txt
done
echo " Total Number of users =====> $UTOT " >> /tmp/userreport.txt
echo " Please find the report at /tmp/userreport.txt "
exit 0
