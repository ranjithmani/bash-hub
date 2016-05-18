#!/bin/bash
#
#USAGE: ./getpasswdexp.sh
MAILID=root@localhost
WDAY=7
grep /bin/bash /etc/passwd |awk -F ":" '{print $1}'>> USERLST
grep /bin/sh /etc/passwd |awk -F ":" '{print $1}' >> USERLST
for i in $(cat USERLST)
do

#For Locked users
if [ `passwd -S $i |awk '{print $2}'` == "LK" ]
then
echo $i >> USERLK
fi

#For password warning
if [ `grep -w $i /etc/shadow | awk -F ":" '{print $3}'` -le  $WDAY ]
then
echo $i >> USERWL
fi

#For Last login details
last $i | head -1 |awk '{print $1"\t"$4" "$5" "$6" "$7"\t"$3}' >> USERLAST

done

#cat USERWL | mail -s "List of users whose password expires less than 7 days" root@localhost
#cat USERLK | mail -s "List of Locked users" root@localhost
#cat USERLAST | mail -s "last login details" root@localhost
echo "List of users whose password expires less than 7 days" >> MAILME
echo "-----------------------------------------------------" >> MAILME
cat USERWL >> MAILME
echo " " >> MAILME
echo "List of Locked users" >> MAILME
echo "--------------------" >> MAILME
cat USERLK >> MAILME
echo " " >> MAILME
echo  "Last Login Details" >> MAILME
echo  "------------------" >> MAILME
cat USERLAST >> MAILME
cat MAILME | mail -s "User activity details" $MAILID
rm -f USERLK
rm -f USERWL
rm -f USERLST
rm -f USERLAST
rm -f MAILME
