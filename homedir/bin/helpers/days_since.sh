#!/bin/bash

old_date_str=$1

old_epoch=$(date --date="$old_date_str" +%s)
now_epoch=$(date +%s)
diff_epoch=$(( $now_epoch - $old_epoch ))
echo $(( $diff_epoch / 24 / 60 / 60 ))
