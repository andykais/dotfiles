#!/bin/bash

FORMAT=$(echo -e "\033[1;33m%w%f\033[0m written at $(date +'%r')")
EXCLUDE_PATTERN="\.(log|aux|dvi|blg|pdf|lock)"
leave=false
clear


function task() {
  echo -ne "\nexecuting $(cat $HOME/bin/data/lastroc.sh)" \
    && output=$(bash $HOME/bin/data/lastroc.sh 0>/dev/null) \
    && clear\
    && echo -ne "[Running \"$@\" on changes in $(pwd) at $(date +'%r')]\n\n"\
    && echo -ne "$output"
}

trap ctrl_c INT
function ctrl_c() {
  leave=true
}
export -f task

echo "$@" > $HOME/bin/data/lastroc.sh

task $@
# while true
# do
  # [[ $leave == true ]] && exit
  # task $@
  # sleep .3
  fswatch -o . | xargs -n1 -I{} bash -c "task" _ {}
  # fswatch -o . | task
  # fswatch -0 -e '.log$' -e '.lock$' -e '.aux$' -e '.git' -e '.tern-port$' -e '.pdf$' -e '.dvi$' . \
    # | xargs echo hoi hi
    # | while read -d "" event
    # do
      # echo 'here'
      # # task $@
    # done
# done
