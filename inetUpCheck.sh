#!/bin/bash

INTERNET_STATUS="UNKNOWN"
TIMESTAMP=`date +%s`
STARTDOWN=TIMESTAMP
STARTUP=TIMESTAMP
INTERVAL=2

while [ 1 ]
 do
    ping -c 1 -W 0.7 8.8.4.4 > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        if [ "$INTERNET_STATUS" != "UP" ]; then
            STARTUP=`date +%s`
            echo "UP   `date +%Y-%m-%dT%H:%M:%S%Z` $((`date +%s`-$TIMESTAMP)) $((`date +%s`-$STARTDOWN))";
            INTERNET_STATUS="UP"
        fi
    else
        if [ "$INTERNET_STATUS" = "UP" ]; then
            STARTDOWN=`date +%s`
            echo "DOWN `date +%Y-%m-%dT%H:%M:%S%Z` $((`date +%s`-$TIMESTAMP)) $((`date +%s`-$STARTUP))";
            INTERNET_STATUS="DOWN"
        fi
    fi
    sleep $INTERVAL
 done;
