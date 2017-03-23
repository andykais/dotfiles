#!/bin/bash

. $HOME/.dotfiles/bin/helpers/print.sh

TMP_FILE=/tmp/pacman_tmp_sort.txt
rm -f $TMP_FILE

[[ -z $(which pacman) ]] && echo "ERROR! no pacman program" && exit


official_packages() {
  grep -Fxv -f <(pacman -Qqm) <(pacman -Qqe)
}
aur_packages() {
  pacman -Qqm
}

list_packages() {
  pacman_command="$1"

  $pacman_command |
  while read package
  do
    line=$(grep -m 1 " installed $package " /var/log/pacman.log)

    original_date=$(perl -ne 'print $1 if /\[(.*?)\]/' <<< "$line")
    formatted_date=$(sed -E 's/02:(..)$/03:\1/' <<< "$original_date")
    numerical_date=$(date --date="$formatted_date" "+%s")
    version_number=$(awk '{print $6}' <<< "$line")
    echo "$numerical_date $package $version_number $original_date" >> $TMP_FILE
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
    echo "usage: sort_pacman.sh [aur]"
    exit
    ;;
esac
