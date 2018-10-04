#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

symlink() {
  file=$1
  target=$2
  if [ -z $file  ] || [ -z $target ]; then
    printf "Bad scripting, pass file & target\n"
  elif [ ! -e $file ]; then
    printf "Bad scripting, src $file doesnt exist\n"
  else
    if [ -e $target ]; then
      if [ -h $target ] && [ "$(readlink -e $target)" = "$file" ]; then
        printf "~${target#$HOME} symlink exists... Skipping\n"
      else
        read -n 1 -p "~${target#$HOME} already exists, replace? (y/n) " choice
        case $choice in
          y|Y)
            printf "\nCreating symlink for $file\n"
            printf "Moving $target to $target.bck"
            mv $target $target.bck
            ln -s $file $target
            ;;
          *)
            printf "\n... Skipping\n"
            ;;
        esac
      fi
    else
      printf "Creating symlink for $file\n"
      ln -sf $file $target
    fi
  fi
}

printf "\nCreating symlinks\n"
printf "==============================\n"
linkables=$( find -H "$DOTFILES/configs-base-dir" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
  target="$HOME/.$( basename $file '.symlink' )"
  symlink $file $target
done

printf "\ninstalling to ~/.config\n"
printf "==============================\n"

if [ ! -d $HOME/.config ]; then
  echo "Creating ~/.config"
  mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )
for config in $DOTFILES/configs-xdg-dir/*; do
  target=$HOME/.config/$( basename $config )
  symlink $config $target
done

printf "\nCreating vim symlinks\n"
printf "==============================\n"
symlink $DOTFILES/configs-xdg-dir/nvim $HOME/.vim
symlink $DOTFILES/configs-xdg-dir/nvim/init.vim $HOME/.vimrc


printf "\nLinking custom scripts\n"
printf "==============================\n"
symlink $DOTFILES/bin $HOME/bin
printf "\n"
