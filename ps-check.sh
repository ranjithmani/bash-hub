#!/bin/bash
#This script will check the system performance at a glance 
a=3
a=$2
while true  
do
echo "--------------------------------------------------------------------------------------------------------------------------------------------";
echo "CPU UTILIZATION BY PROCESS";
echo "==========================";
ps aux |head -1 ;ps aux|grep -v "%CPU" |sort -nr -k3 |head -$1;
echo "--------------------------------------------------------------------------------------------------------------------------------------------";
echo "MEMORY UTILIZATION BY PROCESS";
echo "==============================";
ps aux |head -1 ;ps aux|grep -v "%MEM" |sort -nr -k4 |head -$1;
echo "--------------------------------------------------------------------------------------------------------------------------------------------";
echo "TOTAL NUMBER OF PROCESS RUNNING IN THE SERVERS:`ps -ef |wc -l`";
echo "TOTAL THREADS IN THE SERVER:`ps -efL|wc -l`";
echo "--------------------------------------------------------------------------------------------------------------------------------------------";
sleep $a 
clear
done
