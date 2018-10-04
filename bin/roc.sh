#!/bin/sh
FORMAT=$(echo -e "\033[1;33m%w%f\033[0m written at $(date +'%r')")
EXCLUDE_PATTERN="\.git/index.lock|\.(log|aux|dvi|blg|pdf|tern-port)"
clear
while true
do
        # echo "[Running \"$@\" on files changes in $(pwd) at $(date +'%r')] ..."\
        echo "Executing command..." \
        && echo ""\
        && echo "$@" > $HOME/bin/data/lastroc.sh\
        && output=$(bash $HOME/bin/data/lastroc.sh) \
        && clear \
        && printf '%s\n' "$output" \
        && sleep .3;

    inotifywait --exclude $EXCLUDE_PATTERN -qre close_write --format "$FORMAT" .
  done
