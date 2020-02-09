#!/bin/bash

# fetches the quote of the day if internet allows it
QUOTE_URL=http://quotes.rest/qod.json
# for testing, run alongside
#$ http-server /tmp/
#QUOTE_URL=http://127.0.0.1:8080/qod.json

filename=$1
if [[ ! -f $filename ]]; then
  wget -nv $QUOTE_URL -O $filename >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    rm -f $filename
    exit 1
  fi
fi
