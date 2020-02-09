#!/bin/bash

. ~/bin/helpers/cron-script-helpers.sh

XDG_DATA_DIR=${XDG_DATA_DIR:-$HOME/.local/share}
LAST_RAN_FILE=$XDG_DATA_DIR/clean_machine_last_ran

last_clean_machine_run=$(cat $LAST_RAN_FILE)
if [[ -z "$last_clean_machine_run" ]]
then
  notify_send_from_root "Weekly clean_machine.sh reminder.\nIt has not been run once on this system."
else
  days_since=$(days_since_date "$last_clean_machine_run")
  notify_send_from_root "Weekly clean_machine.sh reminder.\nIt has been $days_since days since the last cleaning."
fi
