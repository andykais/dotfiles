#!/bin/bash

# gets quote of the day if internet allows it
QUOTE_URL=http://quotes.rest/qod.json
# for testing, run alongside
#$ http-server /tmp/
#QUOTE_URL=http://127.0.0.1:8080/qod.json
qod() {
  if [[ ! -f $FILENAME ]]; then
    wget -nv $QUOTE_URL -O $FILENAME >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "Internet is down"
      rm $FILENAME
    fi
  fi
}

jq_quote() {
  if [[ -f $FILENAME ]]; then
    read todays_quote < <(jq -r '.contents.quotes' $FILENAME | jq -r '.[0].quote')
  else
    todays_quote=
  fi
  printf '\"%s\"\n' "${todays_quote}"
}
