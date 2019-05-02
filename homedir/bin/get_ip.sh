#!/bin/bash

ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

echo $ip | mail -s "Raspberry Pi's IP" "kaisea.rpi@gmail.com"
