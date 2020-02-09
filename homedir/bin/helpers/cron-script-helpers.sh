#!/bin/bash

notify_send_from_root() {
  # note that we assume this is used by a per-user crontab
  local user=$(whoami)
  local uid=$(id -u $user)
  local message=$1
  local default_urgency='--urgency=low'
  local urgency=${2:-$default_urgency}
  sudo -u $user DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$(echo -e $message)" "$urgency"
}

days_since_date() {
  local old_date_str=$1
  local old_epoch=$(date --date="$old_date_str" +%s)
  local now_epoch=$(date +%s)
  local diff_epoch=$(( $now_epoch - $old_epoch ))
  echo $(( $diff_epoch / 24 / 60 / 60 ))
}
