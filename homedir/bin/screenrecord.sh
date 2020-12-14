#!/bin/bash

set -e

# screen recording utility
# starts recording for up to a minute using `ffmpeg`
# can be stopped by clicking tray icon `yad` creates

RECORD_DIR=$HOME/Pictures/screenrecord
MAX_DURATION=180
file_type='mp4'

case "$1" in
  "root")
    window_info=`xwininfo -root`
    ;;
  "active")
    window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d' ' -f5`
    window_info=`xwininfo -id $window`
    ;;
  "box")
    echo TODO with xrectsel
    exit 1
  *)
    echo "usage: screenrecord.sh [root | active]"
    exit 1
    ;;
esac

# get recording filename
mkdir -p $RECORD_DIR
shopt -s extglob
last_filename_int=$(ls $RECORD_DIR/recording\(+([0-9])\).* \
  | tail -1 \
  | sed -r 's/.*recording.0*([0-9]*).*/\1/'
)
new_filename_int=$(($last_filename_int + 1))
new_filename_int_padded=$(printf '%03d' $new_filename_int)
FILE="$RECORD_DIR/recording($new_filename_int_padded).${file_type}"


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
