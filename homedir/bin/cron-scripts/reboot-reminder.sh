#!/bin/bash

. ~/bin/helpers/cron-script-helpers.sh

last_reboot=$(who -b | awk '{print $3}')
days_since=$(days_since_date "$last_reboot")
notify_send_from_root "Weekly system reboot reminder.\nIt has been $days_since day(s) since the last reboot."
