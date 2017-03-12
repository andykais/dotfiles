#!/bin/bash

complete 
cp "$(pwd)"/$1 /home/andrew/Pictures/Wallpapers
echo /home/andrew/Pictures/Wallpapers/$1 > /home/andrew/bin/data/back.txt
read -p "reset now? (Y/n): " choice
if [[ $choice -eq "y" || $choice -eq "Y" ]] 
then
	moni
fi
