#!/bin/bash

comicdir=$1



if [ -d "$comicdir" ]
then
	outname=$(echo $comicdir | sed -e 's/\///')
	outname=$(echo $outname | sed -e 's/\ /_/g')
	rarname=$outname'.rar'
	cbrname=$outname'.cbr'
	rar a "$rarname" "$comicdir"
	mv $rarname $cbrname
	echo $outname comic file is created
else
	echo 'not a directory!'
fi
