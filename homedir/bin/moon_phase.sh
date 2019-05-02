#!/bin/bash

CHARS=(
"\xf0\x9f\x8c\x91" #  0 - NEW
"\xf0\x9f\x8c\x91" #  1 - NEW

"\xf0\x9f\x8c\x92" #  2 - WAXING CRESCENT
"\xf0\x9f\x8c\x92" #  3 - WAXING CRESCENT
"\xf0\x9f\x8c\x92" #  4 - WAXING CRESCENT
"\xf0\x9f\x8c\x92" #  5 - WAXING CRESCENT

"\xf0\x9f\x8c\x93" #  6 - FIRST QUARTER
"\xf0\x9f\x8c\x93" #  7 - FIRST QUARTER
"\xf0\x9f\x8c\x93" #  8 - FIRST QUARTER
"\xf0\x9f\x8c\x93" #  9 - FIRST QUARTER

"\xf0\x9f\x8c\x94" # 10 - WAXING GIBBOUS
"\xf0\x9f\x8c\x94" # 11 - WAXING GIBBOUS
"\xf0\x9f\x8c\x94" # 12 - WAXING GIBBOUS
"\xf0\x9f\x8c\x94" # 13 - WAXING GIBBOUS

"\xf0\x9f\x8c\x95" # 14 - FULL
"\xf0\x9f\x8c\x95" # 15 - FULL
"\xf0\x9f\x8c\x95" # 16 - FULL

"\xf0\x9f\x8c\x96" # 17 - WANING GIBBOUS
"\xf0\x9f\x8c\x96" # 18 - WANING GIBBOUS
"\xf0\x9f\x8c\x96" # 19 - WANING GIBBOUS
"\xf0\x9f\x8c\x96" # 20 - WANING GIBBOUS

"\xf0\x9f\x8c\x97" # 21 - LAST QUARTER
"\xf0\x9f\x8c\x97" # 22 - LAST QUARTER
"\xf0\x9f\x8c\x97" # 23 - LAST QUARTER
"\xf0\x9f\x8c\x97" # 24 - LAST QUARTER

"\xf0\x9f\x8c\x98" # 25 - WANING CRESCENT
"\xf0\x9f\x8c\x98" # 26 - WANING CRESCENT
"\xf0\x9f\x8c\x98" # 27 - WANING CRESCENT
"\xf0\x9f\x8c\x98" # 28 - WANING CRESCENT

"\xf0\x9f\x8c\x91" # 29 - NEW
)

PHASE=$(( ( ( $( date --date='00:00' +%s ) - 1386030360 ) % 2551443 ) / 86400 ))
echo -ne "${CHARS[$PHASE]}"
if [ -z "$NONEWLINE" ]
then
    echo
fi
