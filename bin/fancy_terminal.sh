#!/bin/bash

DATE=$(date -d $(date +"%D") +"%s")
FILENAME=/tmp/qod_$DATE.json
TITLE_TAG=~/bin/data/ascii_name.txt

i3-sensible-terminal -e \
  bash -c "\
  . ~/bin/helpers/qod.sh \
  && qod $FILENAME \
  ; printf '\e[34m%b\e[0m\n' '$(cat $TITLE_TAG)' \
  && jq_quote $FILENAME \
  ; $SHELL \
  "
