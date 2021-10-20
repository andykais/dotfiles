#!/bin/bash

display_type="$1"
case "$display_type" in
  "HDMI")
    xrandr --output HDMI2 --auto
    pactl set-card-profile 0 output:hdmi-stereo
    ;;
  "DPI")
    xrandr --output DP1 --auto
    ;;
  *)
    echo "Usage: xrender.sh <HDMI | DPI> [left | right]"
