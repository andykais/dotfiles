#!/bin/bash


wallpaper_dir=~/Pictures/wallpapers
current_wallpaper_cache=$HOME/.fehbg
seconds_to_wait=$((60 * 60))

# gets an alphanumeric list of the wallpapers
get_wallpapers() {
  sorted_wallpapers=$(find "$wallpaper_dir/" -regex ".*\.\(jpg\|gif\|png\|jpeg\)" | sort -n)
  echo "$sorted_wallpapers"
  echo "$sorted_wallpapers" | head -1
}
# gets the last used wallpaper
get_current_wallpaper() {
  if [ -a "$current_wallpaper_cache" ]
  then
    wallpaper_from_cache=$(cat .fehbg | tail -1 | awk '{print $3}' | sed -e "s/^'//" -e "s/'$//" )
    if [ -a "$wallpaper_from_cache" ]
    then
      echo $wallpaper_from_cache
    else
      get_wallpapers | head -1
    fi
  else
    get_wallpapers | head -1
  fi
}
# sets and logs the background image
set_current_wallpaper() {
  echo setting $1
  feh --bg-max "$1"
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
