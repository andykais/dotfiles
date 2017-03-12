#!/bin/bash

#inspired of:
#   http://unix.stackexchange.com/questions/4489/a-tool-for-automatically-applying-randr-configuration-when-external-display-is-p
#   http://ozlabs.org/~jk/docs/mergefb/
#   http://superuser.com/questions/181517/how-to-execute-a-command-whenever-a-file-changes/181543#181543
export STAT_VGA=/sys/class/drm/card0-VGA-1/status
export STAT_HDMI=/sys/class/drm/card0-HDMI-A-1/status
export STAT_DP=/sys/class/drm/card0-DP-1/status


set_monitor() {
    if [[ -z $1 ]]; then
        echo "Usage: set_monitor TURNON [TURNOFFs]"
        exit 1
    fi
    turnon=$1
    xrandr_command=$2
    echo $turnon

    #while inotifywait -e modify,create,delete,open,close,close_write,access $turnon;
    #do
        dmode="$(cat $turnon)"
        if [ "${dmode}" = disconnected ]; then
            /usr/bin/xrandr --auto
            echo "${dmode}"
        elif [ "${dmode}" = connected ];then
            /usr/bin/xrandr --output $xrandr_command
            echo "${dmode}"
        else /usr/bin/xrandr --auto
            echo "${dmode}"
        fi
    #done
}

set_monitor "$STAT_HDMI" "HDMI1 --mode 1600x900"
set_monitor "$STAT_DP" "DP1 --auto --left-of LVDS1"
set_monitor "$STAT_VGA" "VGA --auto"
