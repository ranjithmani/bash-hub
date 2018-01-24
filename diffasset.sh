#!/bin/bash
TT=$(cat $1 |wc -l)
CT=1
if [ -z $3 ]
then
for i in $(cat $1)
do
grep -w $i $2 > /dev/null 2>&1
if [ $? != 0 ]
then
echo "[$CT/$TT] $i:Not present in $2"
else
echo "[$CT/$TT] $i:Present in $2"
fi
CT=$(expr $CT + 1)
done
else
for i in $(cat $1)
do
echo "[$CT/$TT]checking ...."
grep -w $i $2 > /dev/null 2>&1
if [ $? != 0 ]
then
echo $i >> $3
fi
CT=$(expr $CT + 1)
done
fi
