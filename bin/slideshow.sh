#!/bin/bash

# wait (in seconds) for background to change
wait=$((60 * 60))

# in the future, could load files from a general bin/config file
# sed -c -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE
#dir="$(< $HOME/bin/data/slideshow_all.txt)"
dir=~/Pictures/wallpapers

# finds the image files in $dir
# optionally can add --max-depth 1 to keep from searching subdirs
sorted_wallpapers=$(find "$dir/" -regex ".*\.\(jpg\|gif\|png\|jpeg\)" | sort -n)

#used to find place of last used background image
# var storing last used wallpaper
if [ -a "$HOME/bin/data/slideshow_latest.txt" ]
then
  previous_latest="$(cat $HOME/bin/data/slideshow_latest.txt)"
fi
found_latest=false
dont_care_about_latest=false
IFS=$'\n'


while true
do
  # first round starts after latest (if it exists)
  # after that, it loops from the top
  while read line
  do
    if [[ $line == $previous_latest ]]
    then
      found_latest=true
    fi

    if $found_latest || $dont_care_about_latest
    then
      set -x
      feh --bg-max "$line"
      set +x
      fc -ln -1
      echo $line > $HOME/bin/data/slideshow_latest.txt
      sleep $wait
    fi
  done <<< $sorted_wallpapers
  dont_care_about_latest=true
done
