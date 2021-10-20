#!/bin/bash

set -e

i=$(ls ~/Pictures/screenshots | sed 's/.*\([0-9][0-9][0-9]\).*/\1/' | tail -1)
if [ -z $i ]; then
  i="000"
else
  i=$(( 10#$i+1 ))
fi
i=$(printf "%03d\n" $i) # pad zeros
FILE="$HOME/Pictures/screenshots/screenshot($i).png"
if [ -f "$FILE" ]; then
  echo "Screenshot numbering failed. $FILE already exists."
  exit 1
fi

notify-screenshot() {
  notify-send --icon $FILE "Took Screenshot" "${FILE/#$HOME/'~'}"
}

case "$1" in
    "root")
        import -silent -window root $FILE
        notify-screenshot
        ;;
    "box")
        import -silent $FILE
        notify-screenshot
        ;;
    "active")
        window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d' ' -f5`
        echo $window
        import -border -window $window $FILE
        notify-screenshot
        ;;
    *)
        echo "usage: screenshot.sh [root | box]"
        exit 1
        ;;
esac

