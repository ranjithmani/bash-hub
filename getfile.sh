#!/bin/bash
#
#### BULK FILE DOWNLOAD BASED ON THE FILE NAME 
#USAGE : ./getfile.sh
#Please set the Source(DT) and Destination(OP) directory as per your environment
#Created On:08-Sept-2015
#created By:Ranjith Mani
#Warning : This script is purely working on the basis of file name structure , if the file name is not in below structre ,please do not use this script
#File name structre : ZONE_AREA_PARENT_EMPLOYEE_filename
#The selection crietira will work on the first four field 
#
wizard()
{
clear
echo "FILE DOWNLOAD UTILITY"
echo "====================="
echo "Download files by:"
echo "1 .Zone"
echo "2 .Area"
echo "3 .Parent"
echo "4 .Employee"
echo "5 .Quit"
echo "Enter your choice on which criteria you want to download files [ Z,A,P,E,Q ]:"
read ch
case $ch in
        1|Z|z)
        zone
        ;;
        2|A|a)
        area
        ;;
        3|P|p)
        parent
        ;;
        4|E|e)
        emp
        ;;
        5|Q|q)
        exit 0
        ;;
        *)
        echo "Invalid selection ,please chose a valied option."
        sleep 1
        wizard
        ;;
        esac
}
zone()
{
clear
DT=/data/files
OP=/data/downloads
echo "Download all files which belongs to a Zone."
echo "-------------------------------------------"
echo "Enter the Zone name or code [Q for exit]:"
read ZN
if [ $ZN == Q ]
then
wizard
else
dse=$(ls $DT | awk '/'$ZN'/ {print}' |wc -l)
if [ $dse == 0 ]
then
echo "There is no $ZN Zone avaialable , please check the zone name!!!"
sleep 2
zone
else
test -d $OP/ZON_$ZN || mkdir $OP/ZON_$ZN
ls $DT |awk '/'$ZN'/ {print}' >zn.txt
cnt=$(cat zn.txt|wc -l)
for i in `cat zn.txt`
do
cp -pf $DT/$i $OP/ZON_$ZN
done
echo "$cnt files has been downloaded to $OP/ZON_$ZN directory"
fi
fi
rm -f zn.txt
sleep 2
wizard
}
area()
{
clear
DT=/data/files
OP=/data/downloads
echo "Download all files which belongs to a Area."
echo "-------------------------------------------"
echo "Enter the Area name or code [Q for exit]:"
read AR
if [ $AR == Q ]
then
wizard
else
dse=$(ls $DT | awk '/'$AR'/ {print}' |wc -l)
if [ $dse == 0 ]
then
echo "There is no $AR Area avaialable , please check the Area name!!!"
sleep 2
area
else
test -d $OP/ARE_$AR || mkdir $OP/ARE_$AR
ls $DT |awk '/'$AR'/ {print}' >ar.txt
cnt=$(cat ar.txt|wc -l)
for i in `cat ar.txt`
do
cp -pf $DT/$i $OP/ARE_$AR
done
echo "$cnt files has been downloaded to $OP/ARE_$AR directory"
fi
fi
rm -f ar.txt
sleep 2
wizard
}

parent()
{
clear
DT=/data/files
OP=/data/downloads
echo "Download all files which belongs to a Parent."
echo "-------------------------------------------"
echo "Enter the Parent name or code [Q for exit]:"
read PA
if [ $PA == Q ]
then
wizard
else
dse=$(ls $DT | awk '/'$PA'/ {print}' |wc -l)
if [ $dse == 0 ]
then
echo "There is no $PA Parent avaialable , please check the Parent name!!!"
sleep 2
parent
else
test -d $OP/PAR_$PA || mkdir $OP/PAR_$PA
ls $DT |awk '/'$PA'/ {print}' >pa.txt
cnt=$(cat pa.txt|wc -l)
for i in `cat pa.txt`
do
cp -pf $DT/$i $OP/PAR_$AR
done
echo "$cnt files has been downloaded to $OP/PAR_$PA directory"
fi
fi
rm -f pa.txt
sleep 2
wizard
}

emp()
{
clear
DT=/data/files
OP=/data/downloads
echo "Download all files which belongs to a Employee."
echo "-----------------------------------------------"
echo "Enter the Employee name or code [Q for exit]:"
read EM
if [ $EM == Q ]
then
wizard
else
dse=$(ls $DT | awk '/'$EM'/ {print}' |wc -l)
if [ $dse == 0 ]
then
echo "There is no $EM Employee avaialable , please check the Employee name!!!"
sleep 2
emp
else
test -d $OP/EMP_$EM || mkdir $OP/EMP_$EM
ls $DT |awk '/'$EM'/ {print}' >em.txt
cnt=$(cat em.txt|wc -l)
for i in `cat em.txt`
do
cp -pf $DT/$i $OP/EMP_$EM
done
echo "$cnt files has been downloaded to $OP/EMP_$EM directory"
fi
fi
rm -f em.txt
sleep 2
wizard
}

wizard
