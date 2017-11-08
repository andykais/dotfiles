#!/bin/bash

MANGA_SITE=http://mangaseeonline.us
VIEW_COMIC=http://view-comic.com
COMIC_EXTRA=http://www.comicextra.com
# set DEBUG=true in order to get verbose output

DEBUG() {
  $DEBUG && (
    echo -ne $2
    printf "[DEBUG] $1\n"
  )
}
INFO() {
  $DEBUG || echo -ne "$1"
}

wget_options() {
  echo '
    -r
    -D 1.bp.blogspot.com
    -D 2.bp.blogspot.com
    -D 3.bp.blogspot.com
    -D 4.bp.blogspot.com
    -D 217.23.10.62
    -D rc.itdragons.com
    -H
  '
}

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

wget_keep_names() {
  DEBUG 'wget_keep_names'
  wget \
    -np \
    -l1 \
    --random-wait \
    -erobots=off \
    -m \
    $(wget_options) \
    -A jpeg,jpg,png,gif \
    -nd \
    -o $down_dir/logs/site$1.log \
    -P $down_dir/images/$1 \
    $website_string
}

wget_and_name() {
  DEBUG "wget_and_name $1 ($website_string)"
  wget \
    --spider \
    -l1 \
    --force-html \
    $(wget_options) \
    $website_string 2>&1 \
    | tee $down_dir/logs/site$1.log \
    | while read link
    do
      if grep ^-- <<< $link > /dev/null
      then
        link_only=$(sed 's/.* //' <<< $link)
        DEBUG $link_only
      elif grep image/jpeg <<< $link > /dev/null
      then
        # echo $link, $down_dir/images/$1/$(printf '%04d' $getInc)
        DEBUG "downloading: $link_only"
        wget \
          -q \
          -O $down_dir/images/$1/$(printf '%04d' $getInc).jpg \
          $link_only
        ((getInc++))
      fi
    done
}

download() {
  INFO "-==: Chapter $1 ...downloading"
  mkdir -p $down_dir/images/$1
  mkdir -p $down_dir/logs
  website_string=$(curl -Ls -o /dev/null -w %{url_effective} $website_string)
  DEBUG "curled url: $website_string"
  DEBUG "$1"

  $NAME_IN_ORDER \
    && wget_and_name $1 \
    || wget_keep_names $1
}


zip_chapter() {
  INFO "...zipping"
  outfile=$down_dir/$1
  zip -q $outfile.cbz $down_dir/images/$1/* || printf 'OHMYGOshNOimages!!!'
  INFO "...sleeping :==-\n"
}

get_manga() {
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

      download $formatted_chapter
      zip_chapter $formatted_chapter
    fi
  done <<< $urls
  
  if [[ $(bc -l <<< "$current_chapter < $STOP") = 1 ]]; then
    echo "[WARNING] Range exceeded available chapters."
  fi
}

get_comic() {
  increment=${4:-1}

  echo Downloading chapters [$START - $STOP] into $down_dir

  for i in $(seq -f "%06.1f" $START $increment $STOP)
  do
    #url_chapter=$(echo $i | sed 's/^0*.//' | sed 's/\.0//')
    url_chapter=$(printf '%0.1f' $i | sed 's/\.0//')
    case "$TITLE" in
      avatar*)
        website_string=$VIEW_COMIC/$TITLE-part-${url_chapter}
        ;;
      cyborg*|moon-girl*)
        website_string=$VIEW_COMIC/$TITLE-$(printf '%02d' $url_chapter)
        ;;
      rick-and-morty)
        website_string=$COMIC_EXTRA/$TITLE/chapter-$url_chapter/full
        NAME_IN_ORDER=true
        ;;
      duck-avenger|adventure-time*|the-totally-awesome-hulk-2016|over-the-garden-wall*)
        website_string=$COMIC_EXTRA/$TITLE/chapter-$url_chapter/full
        NAME_IN_ORDER=true
        ;;
      *)
        website_string=$VIEW_COMIC/$TITLE-$(printf '%03d' $url_chapter)
        ;;
    esac

    chapter_number=$(sed 's/\./_/' <<< $i)
    chapter_integer=$(printf '%0.0f' $i)

    DEBUG "constructed url: $website_string"
    
    exists && (
      download $chapter_number
      zip_chapter $chapter_number
      [ $chapter_integer != $STOP ] && sleep 20 || sleep 0
    ) || echo $website_string doesnt exist.
  done

  if [[ $(bc -l <<< "$chapter_integer < $STOP") = 1 ]]; then
    echo "[WARNING] Range exceeded available chapters."
  fi
}


# main execution

NON_OPTIONS=0
MANGA_MODE=true
INCREMENT=1
while [[ $# -gt 2 && $# -gt $NON_OPTIONS ]]
do
  key="$1"

  case $key in
    -c|--comic-mode)
      MANGA_MODE=false
      NON_OPTIONS=0
      shift
      ;;
    -i|--increment)
      INCREMENT=$2
      NON_OPTIONS=0
      shift;shift
      ;;
    --debug)
      DEBUG=true
      shift
      ;;
    *)
      NON_OPTIONS=$(( NON_OPTIONS + 1 ))
      ;;
  esac
done


if [ $# -ge 2 ]; then
  TITLE=$1
  down_dir="$HOME/Downloads/wgetter/$TITLE"
  #     2 is a number (can have decimals)    if only #2 is given  || $2 is greater than $3
  if [[ $2 =~ ^[0-9]+(\.[0-9]+)?$ ]] && [[ $# -eq 2 || $(bc -l <<< "$2 > $3") = 1 ]]
  then
    START=${3:-$2}
    STOP=$2
    [ $DEBUG != true ] && DEBUG=false
    NAME_IN_ORDER=false

    if [ $MANGA_MODE = true ]; then
      get_manga
    else
      get_comic
    fi
  else
    echo [ERROR] bad start/stop given from $2 $3
    exit 1
  fi
else
  echo "usage: wgetter.sh [OPTION] manga-name start# stop#
  -c, --comic-mode
  downloads from mangaseeonline.us
  -i, --increment NUM
  increment value (only valid for non manga)
  "
  exit 1
fi
