#!/bin/bash

set -e

notify-path-copy() {
  notify-send "Copied filepath" "${1}"
}

# do it without escaping like bash
# echo -n "$1" | xsel --clipboard

# do it like bash does <tabbed> filenames
printf '%q' "$1" | xsel --clipboard
echo logs > /home/andrew/mcomix_logfile
notify-path-copy $1
