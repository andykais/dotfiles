#!/bin/bash

# #shows traffic on the specified device

# function human_readable {
        # VALUE=$1
        # BIGGIFIERS=( B K M G )
        # CURRENT_BIGGIFIER=0
        # while [ $VALUE -gt 10000 ] ;do
                # VALUE=$(($VALUE/1000))
                # CURRENT_BIGGIFIER=$((CURRENT_BIGGIFIER+1))
        # done
        # #echo "value: $VALUE"
        # #echo "biggifier: ${BIGGIFIERS[$CURRENT_BIGGIFIER]}"
        # echo "$VALUE${BIGGIFIERS[$CURRENT_BIGGIFIER]}"
# }

# ###CHECKS####

# DEVICE=$1
# IS_GOOD=0
# for GOOD_DEVICE in `grep ":" /proc/net/dev | awk '{print $1}' | sed s/:.*//`; do
        # if [ "$DEVICE" = "$GOOD_DEVICE" ]; then
                # IS_GOOD=1
                # break
        # fi
# done
# if [ $IS_GOOD -eq 0 ]; then
        # echo "Device $DEVICE not found. Should be one of these:"
        # grep ":" /proc/net/dev | awk '{print $1}' | sed s/:.*//
        # exit 1
# fi

# ###REAL STUFF
# LINE=`grep $1 /proc/net/dev | sed s/.*://`;
# RECEIVED=`echo $LINE | awk '{print $1}'`
# TRANSMITTED=`echo $LINE | awk '{print $9}'`
# TOTAL=$(($RECEIVED+$TRANSMITTED))

# echo "Transmitted: `human_readable $TRANSMITTED`"
# echo "Received: `human_readable $RECEIVED`"
# echo "Total: `human_readable $TOTAL`"

# SLP=3
# echo "Sleeping $SLP to calculate speed..."
# sleep $SLP

# LINE=`grep $1 /proc/net/dev | sed s/.*://`;
# RECEIVED=`echo $LINE | awk '{print $1}'`
# TRANSMITTED=`echo $LINE | awk '{print $9}'`
# SPEED=$((($RECEIVED+$TRANSMITTED-$TOTAL)/$SLP))

# echo "Current speed: `human_readable $SPEED`/s"


INTERVAL="1"  # update interval in seconds
 
if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        echo shows packets-per-second
        exit
fi
 
IF=$1
 
        R1=`cat /sys/class/net/$1/statistics/rx_packets`
        T1=`cat /sys/class/net/$1/statistics/tx_packets`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_packets`
        T2=`cat /sys/class/net/$1/statistics/tx_packets`
        TXPPS=`expr $T2 - $T1`
        RXPPS=`expr $R2 - $R1`
        echo "TX $1: $TXPPS pkts/s RX $1: $RXPPS pkts/s"

 
INTERVAL="1"  # update interval in seconds
 
if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        exit
fi
 
IF=$1
 
while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        echo "TX $1: $TKBPS kB/s RX $1: $RKBPS kB/s"
      done
