#!/bin/bash

############################################  COLLAGE #############################################
#                                                                                                 #
# mcomix ctrl+c shortcut copies image path to clipboard                                           #
# mpv ctrl+print shortcut extracts current frame to tmp folder and copies image path to clipboard #
#                                                                                                 #
###################################################################################################

set -e

USAGE_STR="Usage: collage.sh file [ file ... ] [options]
Options:
  --help  display this help message
  --fit   collage the images relative to their image ratios"

if [ -z "$COLLAGE_FOLDER" ]
then
  COLLAGE_FOLDER="$HOME/Pictures/collages"
fi
# i=0000
# ls "$COLLAGE_FOLDER" | while read file
# do
#   i=$(echo $file | sed 's/.*\([0-9][0-9][0-9]\).*/\1/')
#   echo eye $i
# done
# echo eye eye $i

i=$(ls "$COLLAGE_FOLDER" | tail -1 | sed 's/.*\([0-9][0-9][0-9]\).*/\1/')
if [ -z $i ]; then
  i="0000"
else
  i=$(( 10#$i+1 ))
fi
i=$(printf "%04d\n" $i) # pad zeros
image_filename="$COLLAGE_FOLDER/collage($i).png"
if [ -f "$image_filename" ]; then
  # safeguard around a stupid regex check
  echo "Screenshot numbering failed. $image_filename already exists."
  exit 1
fi

notify-collage() {
  if [ -z "$QUIET" ]
  then
    echo "(notifications quieted)"
  else
    notify-send --icon $image_filename "Created Collage ${image_filename/#$HOME/'~'}"
  fi
}

screen_width=1920
screen_height=1080
use_even_tiling=true
collage_image_list=()

for arg in "$@"
do
  if [[ $arg == "--help" ]]
  then
    echo -e "$USAGE_STR"
    exit
  elif [[ $arg == "--fit" ]]
  then
    use_even_tiling=false
  else
    collage_image_list+=( "$arg" )
  fi
done

if [[ "${#collage_image_list[@]}" == 0 ]]
then
  echo -e "$USAGE_STR"
  exit 1
fi

if [[ $use_even_tiling == true ]]
then
  image_width=$(($screen_width / $#))
  set -x
  montage "${collage_image_list[@]}" -background black -geometry ${image_width}x${screen_height}+0+0 "$image_filename"
  set +x
else
  set -x
  convert "${collage_image_list[@]}" -resize x${screen_height} +append -background black -resize ${screen_width}x${screen_height} -gravity center -extent ${screen_width}x${screen_height} $image_filename
  # convert "${collage_image_list[@]}" -resize x${screen_height} +append -background black -resize ${screen_width}x -gravity center $image_filename
  set +x
fi
notify-collage
