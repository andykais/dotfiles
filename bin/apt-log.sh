#!/bin/bash

echo $@ >> $HOME/.root-configs/package-managers/os-packages/apt-log.list

sudo apt-get $@
