#!/bin/bash
#
LOG=~/lnxhard.log
#1.Disable unwanted services
echo "`date +%D"-"%T`:Disabling unwanted services." >>$LOG
./disb_serv
#2.Enable Kernel security
echo "`date +%D"-"%T`:Enabling kernel security." >>$LOG
./enb_kern
#3.Set Password policy
echo "`date +%D"-"%T`:Setting password policy." >>$LOG
./enb_pplcy
#4.Setting SSH parameter
echo "`date +%D"-"%T`:Setting SSH parameter." >>$LOG
./enb_ssh
#5.Disable CTRL+ALT+DELETE
echo "`date +%D"-"%T`:Disabling CTRL+ALT+DELETE." >>$LOG
./disb_cad
#6.Enabling Dynamic MOTD
echo "`date +%D"-"%T`:Enabling Dynamic MOTD." >>$LOG
./enb_motd
#7.Disabling GUI
echo "`date +%D"-"%T`:Disabling GUI." >>$LOG
./disb_gui
#8.Setting Banner
echo "`date +%D"-"%T`:Enabling banner." >>$LOG
./enb_bann
#9.Setting BASH TIME format
echo "`date +%D"-"%T`:Enabling BASH time format." >>$LOG
./enb_batf
