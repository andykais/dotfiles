#!/bin/bash

case "$1" in
    "jekyll")
        gnome-terminal --class=htop --name=htop -e '
        /bin/bash -c "source ~/.bash_aliases;
        title jekyll-serve;
        bjs" '
        gnome-terminal -e '
        /bin/bash -c "source ~/.bash_aliases;
        title guard-watch;
        bgu" '
        sleep 1
        google-chrome "http://localhost:4000"
        ;;
    "off")
        ;;
    *)
        echo "usage: devEnvo.sh [jekyll | something else ]"
        exit
        ;;
esac

