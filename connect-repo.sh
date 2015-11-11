#!/bin/bash
#Script to connect the yum repository
#USAGE: ./connect-repo.sh
#Pre-requisite : lsb_release binary
#Created on : 11-Nov-2015
#Created By : Ranjith Mani
RELEASE=`lsb_release -d | awk '{print $4}'|cut -f1 -d .`
if [ $RELEASE == 6 ]
then
OS=`lsb_release -d | awk '{print $2}'`
else
echo "Repo is not available for `lsb_release -d | awk '{print $2"-"$4}'` version"
fi


oracle ()
{
echo "connecting to $OS repo"
slee 2
cd /etc/yum.repos.d/
test -d repobkp || mkdir repobkp
test -f oracle6.repo
if [ $? = 0 ]
then
echo "$OS repo is already available"
exit 2
else
echo "backing up all repos"
mv *.repo repobkp/
cat > oracle6.repo << EOF
[oracle6-repo]
name=Oracle Enterprise Linux 6.7
enabled=1
baseurl=http://172.23.50.113/oracle6
gpgcheck=0
EOF
fi
}
redhat ()
{
echo "connecting to $OS repo"
slee 2
cd /etc/yum.repos.d/
test -d repobkp || mkdir repobkp
test -f rhel6.repo
if [ $? = 0 ]
then
echo "$OS repo is already available"
else
echo "backing up all repos"
mv *.repo repobkp/
cat > rhel6.repo < EOF
[Redhat-repo]
name=Redhat Enterprise Linux 6.7
enabled=1
baseurl=http://172.23.50.112/rhel6
gpgcheck=0
EOF
fi
}
# see how the functions are called.
case $OS in
        Oracle)
        oracle
        ;;
        Redhat)
        redhat
        ;;
        *)
        echo "Repo not available for `lsb_release -d | awk '{print $2"-"$4}'` "
        esac
