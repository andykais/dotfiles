#!/bin/bash


case "$1" in
    "on")
        xset -dpms
        xset s noblank
        xset s off
        ;;
    "off")
        xset +dpms
        xset s on
        xset s blank
        ;;
    *)
        echo "usage: cocaine.sh [on | off]"
        exit
        ;;
esac
