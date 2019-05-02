#!/bin/bash

XDG_DATA_DIR=${XDG_DATA_DIR:-$HOME/.local/share}

wallpaper_dir=~/Pictures/wallpapers
current_wallpaper_log=$XDG_DATA_DIR/current_user_wallpaper
seconds_to_wait=$((60 * 60))
play_animated_backgrounds=true

# do some safety checks before starting
if ! [[ -x $(command -v feh) ]]
then
  echo "'feh' is required for this script."
  exit 1
fi
if [[ $(command -v mpv) ]]
then
  play_animated_backgrounds=true
else
  echo "'mpv' is not present, so animated backgrounds will not play."
fi

# gets an alphanumeric list of the wallpapers
get_wallpapers() {
  sorted_wallpapers=$(find "$wallpaper_dir/" -regex ".*\.\(jpg\|gif\|png\|jpeg\|mp4\|webm\)" | sort -n)
  echo "$sorted_wallpapers"
  echo "$sorted_wallpapers" | head -1
}
# gets the last used wallpaper
get_current_wallpaper() {
  if [ -a "$current_wallpaper_log" ]
  then
    wallpaper_from_log=$(cat "$current_wallpaper_log")
    if [ -a "$wallpaper_from_log" ]
    then
      echo $wallpaper_from_log
    else
      get_wallpapers | head -1
    fi
  else
    get_wallpapers | head -1
  fi
}

get_file_mimetype() {
  file --mime "$1" -F "|" | cut -d"|" -f2 | sed 's/ //' | sed 's/;.*//'
}
mpv_id=""
# sets and logs the background image
set_current_wallpaper() {
  echo setting $1
  echo "$1" > "$current_wallpaper_log"

  mimetype=$(get_file_mimetype "$1")

  pkill -SIGKILL -f MPV_BACKGROUND
  if [[ "$mimetype" == "image/gif" ]] || [[ "$mimetype" =~ video* ]]
  then
    if [[ "$play_animated_backgrounds" == true ]]
    then
      # set an animated background with `mpv`
      # NOTE: if exiting with Ctrl-C, mpv will NOT continue in the background
      nohup bash -c "exec -a MPV_BACKGROUND mpv --wid=0 --really-quiet --mute=yes --loop '$1'" </dev/null >/tmp/mpv_nohup.out 2>&1 &
    fi
  elif [[ "$mimetype" == image* ]]
  then
    echo "FEH TIME" $mimetype
    # set a static background with `feh`
    feh --bg-max "$1"
  fi
}
# gets the next wallpaper from the directory
get_next() {
  current_val=$(get_current_wallpaper)
  found_current=false
  while read wallpaper
  do
    next_val=$wallpaper
    [[ $found_current == true ]] && break
    [[ $wallpaper == $current_val ]] && found_current=true
  done < <(get_wallpapers)
  echo $next_val
}


echo "Wallpaper changes every $(( seconds_to_wait / 60 )) minutes. Press enter to skip ahead."
wallpaper=$(get_current_wallpaper)
while true
do
  set_current_wallpaper "$wallpaper"
  read -t $seconds_to_wait -s
  wallpaper=$(get_next)
done
