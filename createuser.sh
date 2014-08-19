#!/bin/bash
#---------------------------------------------------------------------------
#This script is to create group of users and assign them a common password
#prerequests: chpasswd utility should be available in your system
#USAGE : ./createuser.sh
#--------------------------------------------------------------------------- 
echo "how many user you want to create :"
read a
for(( i = 1 ; i <= $a ; i++ ))
do
echo "enter the $i user name:"
read u
echo $u >>user.txt
done 
echo "Enter the password for user(same for all user):";
read pass;
for j in `cat user.txt`
do
useradd $j ;
echo $j:$pass | chpasswd;
echo "The user $j has been created ..!!";
sleep 1
done
>user.txt

