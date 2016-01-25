#!/bin/bash
#* to get the user collect and format it to fit for MS excel
#* Usage: ./userdetail-excel.sh
#
clear
DATA=/tmp/yblent.txt
echo "IP Address :`ifconfig|grep inet |grep -v inet6|grep -v 127.0.0.1|awk '{print $2}'|cut -f 2 -d :`" >> $DATA
echo "Hostname :`uname -n`" >> $DATA
echo ":" >>$DATA
which lsb_release > /dev/null 2>&1
if [ $? == 0 ]
then
echo "OS Version :`lsb_release -d|awk -F ":" '{print $2}'`" >>$DATA
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
#echo "UserID:`grep $i /etc/passwd |cut -f 3 -d :`" >> $DATA
grep $i /etc/sudoers > /dev/null 2>&1
if [ $? == 0 ]
then
echo "Sudo user :sudo" >>$DATA
else
echo "Sudo user :No" >>$DATA
fi
echo "LastLogin:`last $i |head -1|awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10}'`" >> $DATA
if [ `passwd -S $i|awk '{print $2}' ` == LK ]
then
echo "User status :Locked" >> $DATA
else
echo "User status :Active" >> $DATA
fi
echo "----------------------------------" >>$DATA
done
echo "Details can be found @ /tmp/yblent.txt "
rm -f user.txt
echo "formating output to fit for MS excel......."
sleep 3
echo -e "\n"
cat /tmp/yblent.txt |awk -F ":" '/:/{print $2}' > format.txt
function format()
{
head -4 format.txt | awk '{print}' ORS=','
echo
TT=5
UT=`cat format.txt |wc -l`
while [ $TT -lt $UT ]
do
PT=`expr $TT + 3`
echo ", , , , ,`sed -n "$TT,$PT"p format.txt | awk '{print}' ORS=','`"
TT=`expr $TT + 4`
done
}
format
>/tmp/yblent.txt
>format.txt
