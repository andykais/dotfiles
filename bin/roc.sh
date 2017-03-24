#!/bin/sh
FORMAT=$(echo -e "\033[1;33m%w%f\033[0m written at $(date +'%r')")
clear
while true
do
    clear\
        && echo "[Running \"$@\" on files changes in $(pwd) at $(date +'%r')]"\
        && echo ""\
        && echo "$@" > $HOME/bin/data/lastroc.sh\
        && bash $HOME/bin/data/lastroc.sh 0>/dev/null  \
        && sleep .3;

    inotifywait -qre close_write --format "$FORMAT" .
done
