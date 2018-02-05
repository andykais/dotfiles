#!/bin/bash

wget http://static.die.net/earth/mercator/1600.jpg -O /tmp/earth.jpg
if [ -e /tmp/earth.jpg ]
then
  DISPLAY=:0.0 XAUTHORITY=/home/andrew/.Xauthority feh --bg-max /tmp/earth.jpg
fi
