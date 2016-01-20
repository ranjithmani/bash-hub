#!/bin/bash
#Simple script to collect the user information from server
#It will give the below details:
# * Normal user list , usually more than 500 UID 
# * User Last login detals
# * User status , active or locked 
# USAGE : ./usercollect.sh
#
DATA=/tmp/yblent.txt
echo "Hostname :`uname -n`" >> $DATA
echo "IP Address :`ifconfig|grep inet |grep -v inet6|grep -v 127.0.0.1|awk '{print $2}'|cut -f 2 -d :`" >> $DATA
which lsb_release > /dev/null 2>&1
if [ $? == 0 ]
then
echo "OS Version :`lsb_release -d`" >>$DATA
else
echo "OS Version :`cat /etc/redhat-release`" >>$DATA
fi
awk -F: '{if ($3 >= 500) { print $1 } }' /etc/passwd > user.txt
echo "collecting user data....."
echo "=========> USER DETAILS <=========" >>$DATA
sleep 2
for i in `cat user.txt`
do
echo "Username:$i"  >>$DATA
echo "UserID:`grep $i /etc/passwd |cut -f 3 -d :`" >> $DATA
echo "LastLogin:`last $i |head -1|awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}'`" >> $DATA
if [ `passwd -S $i|awk '{print $2}' ` == LK ]
then
echo "User status : Locked" >> $DATA
else
echo "User status : Active" >> $DATA
fi
echo "----------------------------------" >>$DATA
done
echo "Details can be found @ /tmp/yblent.txt "
rm -f user.txt
