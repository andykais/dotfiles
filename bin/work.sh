#!/bin/bash

display_usage() {
  echo "This script is used to start tmuxinator project sessions."
  echo -e "\nAvailable sessions:\n"

  for session in `ls ~/.tmuxinator | sed -e 's/\..*$//'`; do
    echo -e "\t${session%.*}"
  done

  echo -e "\nExample usage:\n"
  echo -e "\twork on project"
  echo -e "\twork off project\n"
}

if [ $# -ne 2 ]; then
  display_usage
  exit 1
fi

operation=$1
tmuxinator_config=$2

if [ $operation == "on" ]
  then
  tmux has-session -t $tmuxinator_config 2> /dev/null

  if [ $? != 0 ]
  then
    tmuxinator start $tmuxinator_config
  else
    echo "tmux: $tmuxinator_config session is already running."
    tmux attach -t $tmuxinator_config
  fi
fi

if [ $operation == "off" ]
  then
  tmux has-session -t $tmuxinator_config 2> /dev/null

  if [ $? == 0 ]
  then
    for i in `seq 1 10`;
    do
      tmux send-keys -t $tmuxinator_config:$i.1 C-c C-m
      tmux send-keys -t $tmuxinator_config:$i.2 C-c C-m
      tmux send-keys -t $tmuxinator_config:$i.3 C-c C-m
    done

    tmux kill-session -t $tmuxinator_config
  else
    echo "tmux: no $tmuxinator_config session found."
  fi
fi
