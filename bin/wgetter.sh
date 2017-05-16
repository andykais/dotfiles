#!/bin/bash

MANGA_SITE=http://mangaseeonline.us

exists() {
  wget -q --spider $website_string
}

download_index() {
  mkdir -p $down_dir/index
  curl \
    -s \
    $MANGA_SITE/manga/$TITLE \
    > $down_dir/index/$TITLE

  sed -e 's/href="/\nhref="/g' $down_dir/index/$TITLE \
    | sed -n 's/.*href="\([^"]*\)".*/\1/p' \
    | grep read-online \
    | sort -u \
    | sort $sort_algo
}

download() {
  printf "%s" "-==: Chapter $1 ...downloading"
  mkdir -p $down_dir/images/$1
  mkdir -p $down_dir/logs/$1
  website_string=$(curl -Ls -o /dev/null -w %{url_effective} $website_string)
  wget \
    -r \
    -np \
    --random-wait \
    -erobots=off \
    -m \
    -D 1.bp.blogspot.com \
    -D 2.bp.blogspot.com \
    -D 3.bp.blogspot.com \
    -D 4.bp.blogspot.com \
    -D 217.23.10.62 \
    -H \
    -P $down_dir/images/$1 \
    -A jpeg,jpg,png,gif \
    -nd \
    -o $down_dir/logs/site$1.log \
    $website_string
}

zip_chapter() {
  printf "%s" "...zipping"
  outfile=$down_dir/$1
  zip -q $outfile.zip $down_dir/images/$1/*
  mv $outfile.zip $outfile.cbz
  echo "...sleeping :==-"
}

get_manga() {
  down_dir="$HOME/Downloads/wgetter/$TITLE"

  echo Downloading chapters [$START - $STOP] into $down_dir
  num_columns=$(( 4 + $(grep -o '-' <<< "$TITLE" | wc -l) ))
  sort_algo="-rk$(( $num_columns + 1 )),$(( $num_columns + 1 )) -k${num_columns}n,${num_columns}  -t-"

  urls=$(download_index)
  line_chapter_regex="s/\/read-online\/$TITLE-chapter-\([0-9]\+\(.[0-9]\)*\).*/\1/"
  should_download=false
  is_downloading=false

  while read line
  do
    current_chapter=$(sed $line_chapter_regex <<< $line)
    formatted_chapter=$(printf "%06.1f\n" $current_chapter | sed 's/\./_/')

    if [[ $(bc -l <<< "$current_chapter > $STOP") = 1 ]]; then
      should_download=false
      exit
    elif [[ $(bc -l <<< "$current_chapter >= $START") = 1 ]]; then
      should_download=true
      [ $is_downloading = true ] && sleep 20
      is_downloading=true
    fi

    if [ $should_download = true ]; then
      # remove page-1 from links
      website_string=$(sed 's/-page-1.html$//' <<< $line)
      # add site domain to beginning
      website_string=$MANGA_SITE$website_string

      #echo $website_string
      download $formatted_chapter
      zip_chapter $formatted_chapter
    fi
  done <<< $urls
  exit
}

get_comic() {
  manga_name=$1
  first_chapter=$3
  last_chapter=$2
  down_dir="$HOME/Downloads/wgetter/$manga_name"
  increment=${4:-1}

  echo Downloading chapters [$3 - $2] into $down_dir
  case "$manga_name" in
    "Berserk")
      sort_algo="-rk5,5 -k4n,4 -t-"
      ;;
    *)
      sort_algo="-k5n -t\-"
      ;;
  esac


  for i in $(seq -f "%06.1f" $3 $increment $2)
  do
    url_chapter=$(echo $i | sed 's/^0*//' | sed 's/\.0//')
    case "$manga_name" in
      "Berserk")
        website_string=http://mangaseeonline.us/read-online/${manga_name}-chapter-${url_chapter}-index-2.html
        ;;
      avatar*)
        website_string=http://view-comic.com/${manga_name}-part-${url_chapter}
        ;;
      *)
        website_string=http://mangaseeonline.us/read-online/${manga_name}-chapter-${url_chapter}.html
        sort_algo="-k5n"
        ;;
    esac

    chapter_number=$(sed 's/\./_/' <<< $i)
    chapter_integer=$(sed 's/^0*\(.*\)\.[0-9]/\1/'<<< $i)
    echo $website_string
    exists && (
    download $chapter_number
    zip_chapter $chapter_number
    [ $chapter_integer != $last_chapter ] && sleep 20
    )
  done
}


NON_OPTIONS=0
MANGA_MODE=false
INCREMENT=1
while [[ $# -gt 2 && $# -gt $NON_OPTIONS ]]
do
  key="$1"

  case $key in
    -m|--manga-mode)
      MANGA_MODE=true
      NON_OPTIONS=0
      shift
      ;;
    -i|--increment)
      INCREMENT=$2
      NON_OPTIONS=0
      shift;shift
      ;;
    *)
      NON_OPTIONS=$(( NON_OPTIONS + 1 ))
      ;;
  esac
done


if [ $# -ge 2 ]; then
  TITLE=$1
  # if $2 and $3 are both numbers and $2 is greater than $3 or just $2 is given as input
  if [[ $2 =~ ^[0-9]+(\.[0-9])*$ ]] && [[ $# -eq 3 && $(bc -l <<< "$2 > $3") = 1 ]] || [[ $# -eq 2 ]]; then
    START=${3:-$2}
    STOP=$2
    if [ $MANGA_MODE ]; then
      get_manga
    else
      get_comic
    fi
  else
    echo "error: stop < start"
    exit 1
  fi
else
  echo "usage: wgetter.sh [OPTION] manga-name start# stop#
  -m, --manga-mode
  downloads from mangaseeonline.us
  -i, --increment NUM
  increment value (only valid for non manga)
  "
  exit 1
fi
