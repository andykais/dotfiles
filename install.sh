#!/usr/bin/env bash

cd $(dirname 0)

DOTFILES=$HOME/.dotfiles
LOCAL_DOTFILES=$DOTFILES/homedir
LOCAL_XDG_DIR=$LOCAL_DOTFILES/.config

safe-io() {
  command=$@
  if [[ $DRY_RUN == true ]]
  then
    printf "$ $command\n"
  else
    eval "$command"
  fi
}

symlink() {
  file=$1
  target=$2
  if [ -z $file  ] || [ -z $target ]; then
    printf "Bad scripting: pass file & target\n"
  elif [ ! -e $file ]; then
    printf "Bad scripting: src $file doesnt exist\n"
  else
    if [ -e $target ]; then
      if [ -h $target ] && [ "$(readlink -e $target)" = "$file" ]; then
        printf "~${target#$HOME} symlink exists... Skipping\n"
      else
        read -n 1 -p "~${target#$HOME} already exists, replace? (y/n) " choice
        case $choice in
          y|Y)
            printf "\nCreating symlink for $file\n"
            printf "Moving $target to $target.bck\n"
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

printf "Installing dotfiles\n"
[[ $DRY_RUN == true ]] && printf "This is a dry run. No files will be changed"
printf "\nCreating $HOME/* symlinks\n"
printf "==============================\n"
linkables=$( find $LOCAL_DOTFILES -maxdepth 1 -mindepth 1 \( -name '.config' -o -name '.emacs.d' \) -prune -o -print )
for file in $linkables
do
  target="$HOME/$(basename $file)"
  safe-io symlink $file $target
done

printf "\nCreating $HOME/.emacs.d/* symlinks\n"
printf "==============================\n"
emacs_linkables=$( find $LOCAL_DOTFILES/.emacs.d -type f )
for file in $emacs_linkables
do
  target="$HOME/.emacs.d${file#"$LOCAL_DOTFILES/.emacs.d"}"
  target_folder=$(dirname $target)
  safe-io mkdir -p $target_folder
  safe-io symlink $file $target
done

printf "\nCreating $HOME/.config/* symlinks\n"
printf "==============================\n"
config_linkables=$( find $LOCAL_XDG_DIR -type f )
for file in $config_linkables
do
  target="$HOME/.config${file#"$LOCAL_XDG_DIR"}"
  target_folder=$(dirname $target)
  safe-io mkdir -p $target_folder
  safe-io symlink $file $target
done

printf "\nCreating extra vim symlinks\n"
printf "==============================\n"
safe-io symlink $LOCAL_XDG_DIR/nvim/init.vim $HOME/.vimrc


printf "Done.\n"
