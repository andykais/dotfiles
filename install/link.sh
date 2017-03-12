#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

print() {
    if [ -z $2 ]; then
        printf '%s\n' "$1"
    else
        printf "$2" "$1"
    fi
}

symlink() {
    file=$1
    target=$2
    if [ -z $file  ] || [ -z $target ]; then
        print "Bad scripting, pass file & target"
    else
        if [ -e $target ]; then
            if [ -h $target ] && [ "$(readlink -e $target)" = "$file" ]; then
                print "~${target#$HOME} symlink exists... Skipping"
            else
                read -n 1 -p "~${target#$HOME} already exists, replace? (y/n) " choice
                case $choice in
                    y|Y)
                        print "Creating symlink for $file" "\n%s\n"
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

#symlink $HOME/bin $HOME/newbin

print "Creating symlinks" "\n%s\n"
print "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file '.symlink' )"
    symlink $file $target
    #if [ -e $target ]; then
    #echo "~${target#$HOME} already exists... Skipping."
    #else
    #echo "Creating symlink for $file"
    #ln -s $file $target
    #fi
done

print "installing to ~/.config" "\n\n%s\n"
print "=============================="

if [ ! -d $HOME/.config ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )
for config in $DOTFILES/config/*; do
    target=$HOME/.config/$( basename $config )
    symlink $config $target
    #if [ -e $target ]; then
    #echo "~${target#$HOME} already exists... Skipping."
    #else
    #echo "Creating symlink for $config"
    #ln -s $config $target
    #fi
done

print "installing i3 configs" "\n\n%s\n"
print "=============================="

for config in $DOTFILES/i3/*; do
    target=$HOME/.config/i3/$( basename $config )
    symlink $config $target
    #if [ -e $target ]; then
    #echo "~${target#$HOME} already exists... Skipping."
    #else
    #echo "Creating symlink for $config"
    #ln -s $config $target
    #fi
done



# create vim symlinks
# As I have moved off of vim as my full time editor in favor of neovim,
# I feel it doesn't make sense to leave my vimrc intact in the dotfiles repo
# as it is not really being actively maintained. However, I would still
# like to configure vim, so lets symlink ~/.vimrc and ~/.vim over to their
# neovim equivalent.

print "Creating vim symlinks" "\n\n%s\n"
print "=============================="

typeset -A vimfiles
vimfiles[~/.vim]=$DOTFILES/config/nvim
vimfiles[~/.vimrc]=$DOTFILES/config/nvim/init.vim

for file in "${!vimfiles[@]}"; do
    if [ -e ${file} ]; then
        echo "${file} already exists... skipping"
    else
        echo "Creating symlink for $file"
        ln -s ${vimfiles[$file]} $file
    fi
done
echo -e "\n"


print "Linking custom scripts"
print "=============================="
if [ ! -e $HOME/bin ]; then
    print "linking $DOTFILES/bin scripts to $HOME/bin"
    ln -s $DOTFILES/bin $HOME/bin
else
    print "$DOTFILES/bin already exists"
fi
print
