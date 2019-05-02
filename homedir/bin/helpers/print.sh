#!/bin/bash

print() {
    if [ -z $2 ]; then
        printf '%s\n' "$1"
    else
        printf "$2" "$1"
    fi
}
