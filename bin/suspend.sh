#!/bin/bash

# lenovo laptop brightness goes 0 to 15
maxFile=/sys/class/backlight/acpi_video0/max_brightness
sysFile=/sys/class/backlight/acpi_video0/brightness

max=$(cat "$maxFile")
brightness=$(cat "$sysFile")
xbrightness=$(($brightness * 100 / $max))
echo "original $brightness"
echo "xbrightness $xbrightness"
echo "mod $(($xbrightness % 10))"
xbrightness=$(( (10 - $xbrightness % 10) % 10 + $xbrightness))
echo "final $xbrightness"

xbacklight -set $xbrightness
