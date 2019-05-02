#!/bin/bash

#cd $HOME/.root-configs/package-managers/
BIN_FOLDER=./homedir/bin
PKGS_DIR=$HOME/.dotfiles/pkgs

. $BIN_FOLDER/helpers/func_confirm.sh

if hash npm 2>/dev/null; then
  echo "backing up npm"
  npm list -g --depth=0 | sed "s/\/home\/$USER/~/" > $PKGS_DIR/npm.list
fi

if hash apm 2>/dev/null; then
  echo "backing up atom"
  apm list > $PKGS_DIR/apm.list
fi

if hash pip3 2>/dev/null; then
  echo "backing up pip3"
  pip3 freeze --user > $PKGS_DIR/pip3.list
fi

if hash pip2 2>/dev/null; then
  echo "backing up pip2"
  pip2 freeze --user > $PKGS_DIR/pip2.list
fi

if hash gem 2>/dev/null; then
  echo "backing up ruby gems"
  gem list > $PKGS_DIR/gem.list
fi

if hash tlmgr 2>/dev/null; then
  echo "backing up latex packages"
  tlmgr list --only-installed > $PKGS_DIR/tlmgr.list
fi

if [ -f /etc/arch-release ]; then
  echo "backing up explicitly installed arch packages"
  #yaourt -Qq -e --date > $PKGS_DIR/os-packages/pacman.list
  $BIN_FOLDER/sort_pacman.js > $PKGS_DIR/os-packages/pacman.list
  echo "backing up explicitly installed arch aur packages"
  $BIN_FOLDER/sort_pacman.js aur > $PKGS_DIR/os-packages/pacman_aur.list

elif [ -f /etc/debian_version ]; then
  echo "backing up manually installed debian packages"
  ( zcat $( ls -tr /var/log/apt/history.log*.gz ) ; cat /var/log/apt/history.log ) | \
    egrep '^(Start-Date:|Commandline:)' | grep -v aptdaemon | \
    egrep '^Commandline:' | \
    sed 's/Commandline\: //' > $PKGS_DIR/os-packages/apt-get.list
  echo "backing up linux dependencies"
  dpkg --get-selections | grep -v deinstall > $PKGS_DIR/os-packages/softs.list
else
  echo "unknown linux distro"
fi

if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
then
  if confirm "commit and push to github? (Y/n)"; then
    git add --all $HOME/.dotfiles
    git commit -m "backup script"
    git push origin master
  fi
else
  echo "nothing to commit, slow week?"
fi
