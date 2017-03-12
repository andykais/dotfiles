#!/bin/bash

#cd $HOME/.root-configs/package-managers/
PKGS_DIR=$HOME/.dotfiles/pkgs

. $HOME/.dotfiles/bin/helpers/func_confirm.sh

if hash npm 2>/dev/null; then
  echo "backing up npm"
  npm list -g --depth=0 > $PKGS_DIR/npm.list
fi

if hash yarn 2>/dev/null; then
  echo "backing up yarn"
  yarn global ls --no-progress 2> /dev/null | grep info > $PKGS_DIR/yarn.list
fi

if hash apm 2>/dev/null; then
  echo "backing up atom"
  apm list > $PKGS_DIR/apm.list
fi

if hash pip 2>/dev/null; then
  echo "backing up pip"
  pip freeze --user > $PKGS_DIR/pip.list
elif hash pip3 2>/dev/null; then
  echo "backing up pip3"
  pip3 freeze --user > $PKGS_DIR/pip.list
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
  $HOME/.dotfiles/bin/sort_pacman.sh > $PKGS_DIR/os-packages/pacman.list
  echo "backing up explicitly installed arch aur packages"
  $HOME/.dotfiles/bin/sort_pacman.sh aur > $PKGS_DIR/os-packages/pacman_aur.list

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
