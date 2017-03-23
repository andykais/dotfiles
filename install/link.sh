#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

source $DOTFILES/bin/helpers/print.sh

symlink() {
    file=$1
    target=$2
    if [ -z $file  ] || [ -z $target ]; then
        print "Bad scripting, pass file & target"
    elif [ ! -e $file ]; then
	print "Bad scripting, src $file doesnt exist"
    else
        if [ -e $target ]; then
            if [ -h $target ] && [ "$(readlink -e $target)" = "$file" ]; then
                print "~${target#$HOME} symlink exists... Skipping"
            else
                read -n 1 -p "~${target#$HOME} already exists, replace? (y/n) " choice
                case $choice in
                    y|Y)
                        print "Creating symlink for $file" "\n%s\n"
                        print "Moving $target to $target.bck"
                        mv $target $target.bck
                        ln -s $file $target
                        ;;
                    *)
                        print "... Skipping" "\n%s\n"
                        ;;
                esac
            fi
        else
            print "Creating symlink for $file"
            ln -sf $file $target
        fi
    fi
}

print "Creating symlinks" "\n%s\n"
print "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file '.symlink' )"
    symlink $file $target
done

print "installing to ~/.config" "\n\n%s\n"
print "=============================="

if [ ! -d $HOME/.config ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )
for config in $DOTFILES/configs-xdg-dir/*; do
    target=$HOME/.config/$( basename $config )
    symlink $config $target
done

# create vim symlinks
# As I have moved off of vim as my full time editor in favor of neovim,
# I feel it doesn't make sense to leave my vimrc intact in the dotfiles repo
# as it is not really being actively maintained. However, I would still
# like to configure vim, so lets symlink ~/.vimrc and ~/.vim over to their
# neovim equivalent.

print "Creating vim symlinks" "\n\n%s\n"
print "=============================="
symlink $DOTFILES/configs-xdg-dir/nvim $HOME/.vim
symlink $DOTFILES/configs-xdg-dir/nvim/init.vim $HOME/.vimrc


print "Linking custom scripts" "\n\n%s\n"
print "=============================="
symlink $DOTFILES/bin $HOME/bin
print
