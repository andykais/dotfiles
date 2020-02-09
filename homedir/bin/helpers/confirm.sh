#!/bin/bash


# call with a prompt string or use a default
prompt="${1:-Are you sure?} [y/N]" 

read -p "$prompt" -n 1 -r response
printf "\n"
case $response in
    [yY][eE][sS]|[yY]) 
        true
        ;;
    *)
        false
        ;;
esac
