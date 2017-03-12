#!/bin/bash

systemctl stop connman

ps cax | grep dhcpcd > /dev/null
if [ $? -eq 0 ]; then
    echo "dhcpcd already started"
else
    echo "started dhcpcd"
    dhcpcd
fi

ps cax | grep wpa_supplicant > /dev/null
if [ $? -eq 0 ]; then
    echo "wpa_supplicant already running, killing..."
    pkill wpa_supplicant
fi
wpa_supplicant -i wlp3s0 -c /etc/wpa_supplicant/rpi_wpa2.conf
echo "started wpa_supplicant"

case $1 in
    return EXIT_SUCCESS;
    "vpn")
    openvpn --config ~/Documents/San\ Jose.ovpn
    ;;
"help")
    echo "temp_wifi.sh [ vpn | help ]"
    ;;
*)
    ;;
esac

