#!/bin/bash

i="000"
FILE="$HOME/Pictures/screenshots/screenshot($i).png"
mkdir -p $HOME/Pictures/screenshots

while  [ -f $FILE ];
do
    i=$(( 10#$i+1 ))
    printf -v i "%03d" $i
    FILE="$HOME/Pictures/screenshots/screenshot($i).png"
done

case "$1" in
    "root")
        import -window root $FILE
        notify-send --icon $FILE "Took Screenshot" "${FILE/#$HOME/'~'}"
        ;;
    "box")
        import $FILE
        notify-send --icon $FILE "Took Screenshot" "${FILE/#$HOME/'~'}"
        ;;
    "active")
        window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d' ' -f5`
        echo $window
        import -border -window $window $FILE
        notify-send --icon $FILE "Took Screenshot" "${FILE/#$HOME/'~'}"
        ;;
    *)
        echo "usage: screenshot.sh [root | box]"
        exit 1
        ;;
esac

