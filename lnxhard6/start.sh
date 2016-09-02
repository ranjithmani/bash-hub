#!/bin/bash
#
LOG=~/lnxhard.log
#1.Disable unwanted services
echo "`date +%T"-"%D`:Disabling unwanted services." >>$LOG
./disb_serv
#2.Enable Kernel security
echo "`date +%T"-"%D`:Enabling kernel security." >>$LOG 
./enb_kern
