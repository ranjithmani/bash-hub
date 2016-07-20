#!/bin/bash
#Created By : Ranjith Mani
#Created On : 20-July-2016
LOG=/home/ssta/actlog
SERVERS=server.txt
function main()
{
clear
echo -e "\tRemote Administration Utility"
echo -e "\t============================="
echo -e "\t1.List the managed clients."
echo -e "\t2.Check the managed client reachability."
echo -e "\t3.Copy a file to clients."
echo -e "\t4.List Available scripts in clients."
echo -e "\t5.Execute scripts in clients."
echo -e "\t6.Execute custome commands in clients."
echo
echo -en "Choose any of the above option: "
read  ch
case $ch in
        1)
        listme
        sleep 1
        main
        ;;
        2)
        pingme
        sleep 1
        main
        ;;
        3)
        copyme
        sleep 1
        main
        ;;
        4)
        filelist
        sleep 1
        main
        ;;
        5)
        executeme
        sleep 1
        main
        ;;
        6)
        cucmd
        sleep 4
        main
        ;;
        q|Q|quit)
        exit 0
        ;;
        *)
        echo "Enter a valied choice"
        sleep 1
        main
        ;;
        esac
}

function listme()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
echo "Listing the managed clients"
for l in `cat $SERVERS`
do
echo $l
sleep 0.5
done
}

function pingme()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
echo "Checking managed clients"
for i in `cat $SERVERS`
do
ping -c1 $i >> /dev/null 2>&1
if [ $? == 0 ]
then
echo -e "[$i]#############################################\033[32m [OK]"; tput sgr0
else
echo -e "[$i]#############################################\033[31m [Failed]"; tput sgr0
fi
sleep 0.5
done
}

function copyme()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
echo
echo "please put scripts/files in /home/ssta/scripts directory to copy , please find list of files in scripts directory:"
echo
ls /home/ssta/scripts
echo
echo -en "Please enter the file name which you want to copy to all the clients:"
read file
echo "$file will be copied to all the clients.!!!!"
for i in `cat $SERVERS`
do
scp -prv /home/ssta/scripts/$file $i:/home/ssta/scripts/ >> $LOG 2>&1
if [ $? == 0 ]
then
echo -e "[$i-->$file]#############################################\033[32m [Copied]"; tput sgr0
else
echo -e "[$i-->$file]#############################################\033[31m [Failed]"; tput sgr0
fi
sleep 1
done
}

function filelist()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
clear
echo
echo "############### Listing files in the clients ################"
for i in `cat $SERVERS`
do
echo -e "\033[32m [$i]"; tput sgr0
ssh $i "ls -lrth /home/ssta/scripts/"
echo
sleep 1
done
}

function executeme()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
echo
echo "Available scripts:"
cd /home/ssta/scripts/
echo *
cd ~
echo
echo -en "which script you want execute: "
read scr
echo -en "Do you want to pass any arguments to the script[y|n]: "
read ag
if [ $ag == y ]
then
echo -en "Enter the Argument: "
read arg
fi
echo -en "You want to run $scr  in all clients [y|n]:"
read q
if [ $q == y ]
then
for i in `cat $SERVERS`
do
echo -e "\033[32m [$i]"; tput sgr0
ssh -t $i "sudo /home/ssta/scripts/$scr $arg"
echo
done
else
echo "Enter the server name:"
read ip
ssh -t $ip "sudo /home/ssta/scripts/$scr $arg"
fi
unset q
unset ip
}

function cucmd()
{
LOG=/home/ssta/actlog
SERVERS=server.txt
echo -en "Enter the command: "
read ccm
echo -en "You want to run $ccm  in all clients [y|n]:"
read q
if [ $q == y ]
then
for i in `cat $SERVERS`
do
echo -e "\033[32m [$i]"; tput sgr0
ssh -t $i "sudo $ccm"
echo
done
else
echo -en "Enter the server name:"
read ip
ssh -t $ip "$ccm"
fi
unset q
unset ip
}


main
