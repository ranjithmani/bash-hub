#!/bin/bash
#Description : To print system active user info
#usage       : ./printuser.sh
#Created By  : Ranjith Mani
#Created On  : 26-Aug-2016
#

function getme()
{
clear
myuser=$1
echo "      User : $myuser"
echo "        ID : `id -u  $myuser`"
echo "     P-GID : `id -g $myuser`"
echo "    S-GIDS : `id -G $myuser`"
echo "     SHELL : `grep ^$myuser /etc/passwd | cut -f 7 -d :`"
if [ `passwd -S $myuser |awk '{print $2}'` == PS ]
	then 
	echo "     STATE : Active"
	else
	echo "     STATE : Inactive"
fi
echo "Last Login : `last $myuser|head -1 |awk '{print $4" "$5" "$6" "$7}'`"
echo " "
}

awk -F: '{if ($3 >= 500) { print $1 } }' /etc/passwd > user.txt
#cat /etc/passwd | cut -f 1 -d : > user.txt
for i in `cat user.txt`
do
getme $i
sleep 1
done
rm -f user.txt
