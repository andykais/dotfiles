#!/bin/bash

TMP_FILE=/tmp/pacman_tmp_sort.txt
rm -f $TMP_FILE

[[ -z $(which pacman) ]] && echo "ERROR! no pacman program" && exit


official_packages() {
  pacman -Qqe | grep -v '$(pacman -Qqm)'
}
aur_packages() {
  pacman -Qqm
}

list_packages() {
  pacman_command="$1"

  $pacman_command | while read package
  do
    line=$(grep -m 1 " installed $package " /var/log/pacman.log)

    original_date=$(echo $line | perl -ne 'print $1 if /\[(.*?)\]/')
    version_number=$(echo $line | awk '{print $6}')
    formatted_date=$(date --date="$original_date" "+%s")
    echo "$formatted_date $package $version_number $original_date" >> $TMP_FILE
  done
  sort -k 1 $TMP_FILE | awk '{print $2}'
}



case "$1" in
  "")
    list_packages "official_packages"
    ;;
  "aur")
    list_packages "aur_packages"
    ;;
  *)
    echo "usage: cocaine.sh [on | off]"
    exit
    ;;
esac
