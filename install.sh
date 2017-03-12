#!/usr/bin/env bash

echo "Installing dotfiles"

source $HOME/.dotfiles/install/link.sh


echo "creating vim directories"
mkdir -p ~/.vim-tmp

echo "creating npm directories"
mkdir -p ~/.npm-packages

#echo "Configuring zsh as default shell"
#chsh -s $(which zsh)

echo "Done."
