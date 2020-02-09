#!/bin/bash

. ~/bin/helpers/cron-script-helpers.sh

last_system_upgrade=$(grep 'starting full system upgrade' /var/log/pacman.log | tail -1 | awk '{print $1}' | tr -d '[]')

if [[ -z "$last_system_upgrade" ]]
then
  notify_send_from_root "Weekly system upgrade reminder.\nNone have occurred yet."
else
  days_since=$(days_since_date "$last_system_upgrade")
  notify_send_from_root "Weekly system upgrade reminder.\nIt has been $days_since days since the last upgrade." "--urgency=low"
fi
