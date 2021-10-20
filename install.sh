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
      if [ -h $target ] && [ "$(readlink -e $target)" = $file ]; then
        printf "~${target#$HOME} symlink exists... Skipping\n"
      else
        read -n 1 -p "~${target#$HOME} already exists, replace? (y/n) " choice
        case $choice in
          y|Y)
            printf "\nCreating symlink for $file\n"
            printf "Moving $target to $target.backup\n"
            mv $target $target.backup
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
link-linkables() {
  local linkable_dir="$1"
  local linkables=$(find $linkable_dir -maxdepth 1 -mindepth 1 -print)
  for file in $linkables
  do
    case $file in
      "$LOCAL_DOTFILES/.config"      |\
      "$LOCAL_DOTFILES/.config/nvim" |\
      "$LOCAL_DOTFILES/.gnupg")
        link-linkables $file
        ;;
      *)
        relative_path=${file#"$LOCAL_DOTFILES/"}
        homedir_target="$HOME/$relative_path"
        # target="$HOME/$(basename $file)"
        safe-io symlink $file $homedir_target
        ;;
    esac
  done
}
link-linkables $LOCAL_DOTFILES
exit

# printf "\nCreating $HOME/.config/* symlinks\n"
# printf "==============================\n"
# config_linkables=$( find $LOCAL_XDG_DIR -type f )
# for file in $config_linkables
# do
#   target="$HOME/.config${file#"$LOCAL_XDG_DIR"}"
#   target_folder=$(dirname $target)
#   safe-io mkdir -p $target_folder
#   safe-io symlink $file $target
# done

# printf "\nCreating extra vim symlinks\n"
# printf "==============================\n"
# safe-io symlink $LOCAL_XDG_DIR/nvim/init.vim $HOME/.vimrc
# safe-io mkdir -p $HOME/.vim-tmp


printf "Done.\n"
