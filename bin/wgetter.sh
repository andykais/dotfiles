#!/bin/bash

#N=502
N=192
i=0

manga_name="Medaka-Box"
down_dir="$HOME/Downloads/wgetter/$manga_name/"

#while [ $i -lt $N ]; do
  #echo -==: downloading chapter $i :==-
  ## old locations
  ##echo http://a2.mangasee.co/manga/\?series\=kingdom\&chapter\=$i
  ##echo http://mangaseeonline.net/read-online/Kingdom-chapter-$i.html
  #mkdir -p $down_dir$i
  #wget \
    #-r \
    #-np \
    #--random-wait \
    #-erobots=off \
    #-m \
    #-D 2.bp.blogspot.com \
    #-H \
    #-P $down_dir$i \
    #http://mangaseeonline.net/read-online/${manga_name}-chapter-$i.html \
    #-A jpeg,jpg,png,gif \
    #-nd \
    #-o site$i.log
  #sleep 30
  #let i=i+1
#done

echo "do this afterward:"
cd $down_dir
for dir in $(find . -type d); do zip $dir.zip $dir -r; done
perl-rename 's/\d+/sprintf("%04d", $&)/e' *
perl-rename 's/.zip/.cbz/' *.zip
mkdir -p zips
mv *.cbz zips
