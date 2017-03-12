#!/bin/bash

export DATE=$(date -d $(date +"%D") +"%s")
export FILENAME=/tmp/qod_$DATE.json
TITLE_TAG=~/bin/data/ascii_name.txt

urxvtc -e \
  bash -c "\
  . ~/bin/helpers/qod.sh \
  && qod \
  ; cat $TITLE_TAG \
  && jq_quote \
  ; $SHELL \
  "
  #&& read todays_quote < <(jq -r '.quote' $FILENAME) \
