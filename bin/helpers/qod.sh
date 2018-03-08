#!/bin/bash

# gets quote of the day if internet allows it
QUOTE_URL=http://quotes.rest/qod.json
# for testing, run alongside
#$ http-server /tmp/
#QUOTE_URL=http://127.0.0.1:8080/qod.json

qod() {
  local filename=$1
  if [[ ! -f $filename ]]; then
    wget -nv $QUOTE_URL -O $filename >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "Internet is down"
      rm -f $filename
    fi
  fi
}

jq_quote() {
  local filename=$1
  if [[ -f $filename ]]; then
    read todays_quote < <(jq -r '.contents.quotes' $filename | jq -r '.[0].quote')
    printf '\"%s\"\n' "$todays_quote"
  fi
}
