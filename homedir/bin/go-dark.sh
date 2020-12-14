#!/bin/bash

set -x

pkill dropbox
pkill google-chrome

sudo systemctl stop avahi-daemon.socket
sudo systemctl stop avahi-daemon.service
sudo systemctl stop avahi-dnsconfd.service
sudo systemctl mask avahi-daemon.socket
sudo systemctl mask avahi-daemon.service
sudo systemctl mask avahi-dnsconfd.service

# systemctl restart opensnitch
opensnitch-ui &
sudo opensnitchd  \
  --rules-path ./.config/opensnitch/rules \
  -ui-socket unix:///tmp/osui.sock
