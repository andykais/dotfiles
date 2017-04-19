#!/bin/bash

RECORD_DIR=$HOME/Pictures/screenrecord
i="000"
FILE="$RECORD_DIR/recording($i).gif"
DURATION=5

mkdir -p $RECORD_DIR
while  [ -f $FILE ];
do
  i=$(( 10#$i+1 ))
  printf -v i "%03d" $i
  FILE="$RECORD_DIR/recording($i).gif"
done

#echo "${@:2}"
if [ ! -z "$1" ]; then
  DURATION=$1
fi

byzanz-record --duration=$DURATION $FILE
