#!/bin/bash


#manga_name="Kingdom"
#manga_name="Berserk"
#manga_name="Dragon-Ball"

download() {
  printf "%s" "-==: Chapter $1 ...downloading"
  mkdir -p $down_dir$1
  wget \
    -r \
    -np \
    --random-wait \
    -erobots=off \
    -m \
    -D 2.bp.blogspot.com \
    -H \
    -P $down_dir$1 \
    -A jpeg,jpg,png,gif \
    -nd \
    -o ${down_dir}site$1.log \
    "http://mangaseeonline.us/read-online/${manga_name}-chapter-${1}-index-2.html"
  #http://mangaseeonline.us/read-online/${manga_name}-chapter-$i.html
}

zip_chapter() {
  printf "%s" "...zipping"
  outfile=${down_dir}zips/$1
  mkdir -p ${down_dir}zips
  zip -q $outfile.zip $down_dir$1/*
  mv $outfile.zip $outfile.cbz
  echo "...sleeping :==-"
}

get_range() {
  manga_name=$1
  down_dir="$HOME/Downloads/wgetter/$manga_name/"

  echo Downloading chapters [$3 - $2] into $down_dir
  for i in $(seq -f "%04g" $3 $2)
  do
    download $i
    zip_chapter $i
    sleep 20
  done
}

if [ -z $3 ]; then
  echo usage: wgetter.sh [manga name] [start#] [stop#]
  exit 1
elif [ $3 -gt $2 ]; then
  echo "error: stop < start"
  exit
else
  get_range $1 $2 $3
fi
