#!/bin/bash

old_date_str=$@

old_epoch=$(date "+%s" --date="$old_date_str")
now_epoch=$(date "+%s")
diff_epoch=$(( $now_epoch - $old_epoch ))
echo $(( $diff_epoch / 24 / 60 / 60 ))
