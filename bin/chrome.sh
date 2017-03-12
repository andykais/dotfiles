#!/bin/bash




# this line works with chrome but put the focus on chrome
editor=`xdotool getwindowfocus`
xdotool search --onlyvisible --class "chrome" windowfocus key 'ctrl+r'
xdotool windowfocus $editor
