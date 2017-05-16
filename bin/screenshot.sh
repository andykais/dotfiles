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
        notify-send --icon $FILE "Took Screenshot" "filename $FILE"
        ;;
    "box")
        import $FILE
        notify-send --icon $FILE "Took Screenshot" "filename $FILE"
        ;;
    *)
        echo "usage: screenshot.sh [root | box]"
        exit
        ;;
esac

