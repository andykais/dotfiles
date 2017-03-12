#!/bin/bash

systemctl is-enabled connman
[[ $? == 0 ]] && exec cmst -w5 -m

systemctl is-enabled NetworkManager
[[ $? == 0 ]] && exec nm-applet
