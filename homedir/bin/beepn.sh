#!/bin/bash


$@

# TODO add notifications
if [[ $? -eq 0 ]]
then
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga
else
  paplay /usr/share/sounds/freedesktop/stereo/dialog-error.oga
fi
