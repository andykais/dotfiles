#!/bin/bash

[[ -z $(which pacman) ]] && echo "ERROR! no pacman program" && exit


official_packages() {
  pacman -Qeni | grep 'Name\|Install Date\|Version' | sed 's/^.*:\s//g' | paste - - -
}
aur_packages() {
  pacman -Qmi | grep 'Name\|Install Date\|Version' | sed 's/^.*:\s//g' | paste - - -
}

list_packages() {
  pacman_command="$1"

  $pacman_command \
    | awk 'BEGIN{FS=OFS="\t"}{
      cmd = "date -d \""$3"\" +%s";
      cmd | getline d;
      print $1, $2, d;
      close(cmd);
    }' \
    | sort -k 3 \
    | awk 'BEGIN{FS=OFS="\t"}{
      cmd = "date -d \"@"$3"\"";
      cmd | getline d;
      print $1, $2, d;
      close(cmd);
    }' \
    | column -t
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
