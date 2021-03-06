#!/bin/bash
#Script to connect the yum repository
#USAGE: ./connect-repo.sh
#Pre-requisite : lsb_release binary
#Created on : 11-Nov-2015
#Created By : Ranjith Mani
which lsb_release > /dev/null 2>&1
if [ $? = 0 ]
then
INI=`lsb_release -d | awk '{print $2}'`
if [ $INI = "Red" ]
then
OS=`lsb_release -d | awk '{print $2$3}'`
RELEASE=`lsb_release -d | awk '{print $8}'|cut -f1 -d .`
else
RELEASE=`lsb_release -d | awk '{print $4}'|cut -f1 -d .`
OS=`lsb_release -d | awk '{print $2}'`
fi
else
clear
echo "No LSB_RELEASE package installed, select the OS release manually."
echo -e "\t *Redhat"
echo -e "\t *Oracle"
echo -e "\t Quit"
echo "please enter the OS:"
read OS
fi

oracle ()
{
echo "connecting to $OS repo"
sleep 2
cd /etc/yum.repos.d/
test -d repobkp || mkdir repobkp
test -f oracle6.repo
if [ $? = 0 ]
then
echo "$OS repo is already available"
exit 2
else
echo "backing up all repos"
mv *.repo repobkp/ > /dev/null
cat > oracle6.repo << EOF
[oracle6-repo]
name=Oracle Enterprise Linux 6.7
enabled=1
baseurl=http://172.23.50.113/oracle6
gpgcheck=0
EOF
echo "Repo has been set for $OS Enterprise Linux 6"
fi
}
redhat ()
{
echo "connecting to $OS repo"
sleep 2
cd /etc/yum.repos.d/
test -d repobkp || mkdir repobkp
test -f rhel6.repo
if [ $? = 0 ]
then
echo "$OS repo is already available"
else
echo "backing up all repos"
mv *.repo repobkp/ > /dev/null
cat > rhel6.repo << EOF
[Redhat-repo]
name=Redhat Enterprise Linux 6.7
enabled=1
baseurl=http://172.23.50.112/rhel6
gpgcheck=0
EOF
echo "Repo has been set for $OS Enterprise Linux 6"
fi
}
#See how the functions are called .
case $OS in
       oracle|Oracle)
        oracle
        ;;
        Redhat|redhat|RedHat)
        redhat
        ;;
        Q|q|Quit|quit)
        exit 4
        ;;
        *)
        echo "Repo not available for `lsb_release -d | awk -F ":" '{print $2}'` "
        esac
