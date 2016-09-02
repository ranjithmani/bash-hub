#!/bin/bash
#
LOG=~/lnxhard.log
#1.Disable unwanted services
echo "`date +%T"-"%D`:Disabling unwanted services." >>$LOG
./disb_serv 
