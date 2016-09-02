#!/bin/bash
# USAGE: To rotate and start nmon capture 
# script created : Shamelessly copied from someones script.
RDAYS=30

function rotate()
{

        cd /var/log/nmon_reports/

        ls > rotate.txt

        while read FILE
        do
                TDATE=`date +%s`
                CDATE=`stat -c %Y $FILE`
                DIFF=$(( 86400 * ${RDAYS} ))

                ISDEL=$(( TDATE - CDATE ))

                if [ $DIFF -le $ISDEL ]
                then
                        rm -rvf $FILE > /dev/null
                fi

        done < rotate.txt

rm -f rotate.txt > /dev/null

}

cd /var/log/nmon_reports/
/usr/bin/nmon -s 600 -c 144 -f -t -m /var/log/nmon_reports/
chmod o+r /var/log/nmon_reports/*.nmon
rotate
