#!/bin/bash

confirm() {
       # call with a prompt string or use a default
    read -p "${1:-Are you sure?} [y/N]" -n 1 -r response
    printf "\n"
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}
