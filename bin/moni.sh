#!/bin/bash


xrandr -q | grep ' connected' | awk '{print $1}' | while read line
do
  if [ "$line" != "LVDS1" ]
  then
    if [ "$1" == "off" ]
    then
      xrandr --output "$line" --off
      pactl set-card-profile 0 output:analog-stereo

    else
      #xrandr --output $line --left-of LVDS1 --auto
      xrandr --output $line --left-of LVDS1 --auto
      if [ "$line" == "HDMI1" ]
      then
        pactl set-card-profile 0 output:hdmi-stereo
      fi
    fi
  fi

done

feh --bg-max "$(< $HOME/bin/data/slideshow_latest.txt)"
