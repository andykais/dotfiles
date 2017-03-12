#!/bin/bash

usage() {
    echo usage: swap_ws.sh [ window# ]
    exit 1
}

#if [ -z "$1" ] || [ -z "$2" ]
#then
#usage
#else
#if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$2" =~ ^[0-9]+$ ]] && [ "$1" -ne "$2" ]
#then
#i3-msg "rename workspace $1 to temporary; rename workspace $2 to $1; rename workspace temporary to $2"
#else
#usage
#fi
#fi

current_ws=$(( $(xprop -root | awk '/_NET_CURRENT_DESKTOP\(CARDINAL\)/{print  $NF}') + 1 ))

if [ -z "$1" ]
then
    usage
else
    if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$current_ws" =~ ^[0-9]+$ ]] && [[ $1 -ne $current_ws ]]
    then
        echo  "rename workspace $current_ws to temporary; rename workspace $1 to $current_ws; rename workspace temporary to $1"
        i3-msg "rename workspace $current_ws to temporary; rename workspace $1 to $current_ws; rename workspace temporary to $1"
    else
        usage
    fi
fi


