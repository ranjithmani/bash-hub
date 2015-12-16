#!/bin/bash
#calculate average of list of values supplied.
cnt=`cat  calc | wc -l`
sum=0
for i in `cat calc`
do
sum=`echo "$sum + $i" |bc `
done
total=`echo "$sum/$cnt" |bc`
echo " the Average  is : $total"
