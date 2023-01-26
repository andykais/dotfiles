#!/bin/bash

set -e


notify-screenshot() {
  notify-send --icon $FILE "Took Screenshot" "${FILE/#$HOME/'~'}"
}



newest_index=$(ls ~/Pictures/screenshots \
  | sed 's/screenshot(//' \
  | sed 's/).*//' \
  | sort -V \
  | tail -1)


if [ -z $newest_index ]; then
  newest_index="0000"
else
  newest_index=$(( 10#$newest_index+1 ))
fi
newest_index=$(printf "%04d\n" $newest_index) # pad zeros
FILE="$HOME/Pictures/screenshots/screenshot($newest_index).png"
if [ -f "$FILE" ]; then
  echo "Screenshot numbering failed. $FILE already exists."
  exit 1
fi

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
