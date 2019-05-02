#!/bin/bash

set -e

# screen recording utility
# starts recording for up to a minute using `ffmpeg`
# can be stopped by clicking tray icon `yad` creates

RECORD_DIR=$HOME/Pictures/screenrecord
MAX_DURATION=60
i="000"
filename="$RECORD_DIR/recording($i)"
file_type='mp4'

mkdir -p $RECORD_DIR
while [[ $(ls $filename.*) ]]
do
  i=$(( 10#$i+1 ))
  printf -v i "%03d" $i
  filename="$RECORD_DIR/recording($i)"
  echo $filename
done
FILE="$filename.${file_type}"

case "$1" in
  "root")
    window_info=`xwininfo -root`
    ;;
  "active")
    window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d' ' -f5`
    window_info=`xwininfo -id $window`
    ;;
  *)
    echo "usage: screenrecord.sh [root | active]"
    exit 1
    ;;
esac

# get recording dimensions
width=`printf "$window_info"  | grep Width                   | awk '{print $2}'`
height=`printf "$window_info" | grep Height                  | awk '{print $2}'`
x=`printf "$window_info"      | grep 'Absolute upper-left X' | awk '{print $NF}'`
y=`printf "$window_info"      | grep 'Absolute upper-left Y' | awk '{print $NF}'`


on_stop_recording() {
  kill $ffmpeg_pid
  END_TIME=$(date +%s)
  duration=$((END_TIME - START_TIME))
  yad_pid=`cat $yad_pid_file`
  kill $yad_pid
  notify-send --icon $FILE "Recorded Screen for ${duration}s" "${FILE/#$HOME/'~'}"
}

START_TIME=$(date +%s)

# record screen using x11grab
ffmpeg \
  -t $MAX_DURATION \
  -video_size ${width}x${height} \
  -framerate 25 \
  -f x11grab -i :0.0+${x},${y} \
  $FILE \
  & ffmpeg_pid=$!

# export everything so yad's command can see it
export -f on_stop_recording
export FILE=$FILE
export ffmpeg_pid=$ffmpeg_pid
export START_TIME=$START_TIME
export yad_pid_file="/tmp/yad-$(date +%s).pid"

# opens an icon in the system tray
yad \
  --notification \
  --image=/usr/share/icons/Adwaita/16x16/actions/media-record.png \
  --text="Started recording at $(date +'%H:%M:%S %p'). Click finish recording" \
  --command 'bash -c on_stop_recording' \
  & echo $! > $yad_pid_file
