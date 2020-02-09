#!/bin/bash


set -e
cd "$(dirname "$0")"


BIN_FOLDER=./homedir/bin
PKGS_DIR=$HOME/.dotfiles/packager-archives
XDG_DATA_DIR=${XDG_DATA_DIR:-$HOME/.local/share}
LAST_RAN_FILE=~/.local/share/clean_machine_last_ran


confirm=$BIN_FOLDER/helpers/confirm.sh
days_since=$BIN_FOLDER/helpers/days_since.sh
. ~/bin/helpers/emoticons.sh


archive() {
  local escaped_home=$(echo $HOME | sed -e 's/[\/&]/\\&/g')
  local backup_command=$1
  local archive_file=$2
  # we do not pipe these directly so that `set -e` picks up on this command failing
  # for the same reason this variable cant be local, weird
  echo $ $backup_command
  package_list=$($backup_command)
  # we write after the pipe completes to only save the output on success
  # to avoid saving the user's home directory to the git repo, we replace it with ~
  echo -e "$package_list" | sed "s/$escaped_home/~/" > $PKGS_DIR/$archive_file
  echo "Archiving $(wc -l $PKGS_DIR/$archive_file) items."
}


if [[ -f $LAST_RAN_FILE ]]
then
  last_ran_at=$(cat $LAST_RAN_FILE)
  days_since_last_run=$($days_since $last_ran_at)
  echo Last ran: $last_ran_at
  echo
else
  echo Running backup.sh for the first time.
  echo
fi


$confirm 'Archive npm global packages?' \
  && archive "npm list -g --depth=0" npm.list

$confirm 'Archive atom package manager (apm)?' \
  && archive 'apm list' apm.list

$confirm 'Archive pip3 user packages?' \
  && archive 'pip3 freeze --user' pip3.list

$confirm 'Archive pip2 user packages?' \
  && archive 'pip2 freeze --user' pip2.list

$confirm 'Archive ruby gems?' \
  && archive 'gem list' gem.list

$confirm 'Archive latex packages?' \
  && archive 'tlmgr list --only-installed' tlmgr.list


if [[ -f /etc/arch-release ]]; then
  $confirm 'Archive Arch Linux packages?' \
    && archive "$BIN_FOLDER/sort_pacman.js " arch-linux.list

  $confirm 'Archive Arch Linux AUR packages?' \
    && archive "$BIN_FOLDER/sort_pacman.js aur" arch-linux-aur.list

elif [[ -f /etc/debian_version ]]; then
  if $confirm 'Archive Debian packages?'
  then
    echo "backing up manually installed debian packages"
    ( zcat $( ls -tr /var/log/apt/history.log*.gz ) ; cat /var/log/apt/history.log ) | \
      egrep '^(Start-Date:|Commandline:)' | grep -v aptdaemon | \
      egrep '^Commandline:' | \
      sed 's/Commandline\: //' > $PKGS_DIR/debian-apt-get.list
    echo "backing up linux dependencies"
    dpkg --get-selections | grep -v deinstall > $PKGS_DIR/debian-softs.list
  fi
else

  echo "Unknown Linux distro. I cannot backup system packages. ¯\_(ツ)_/¯"
fi


if [[ $(git status -s) == "" ]]
then
  echo "Nothing new to commit, slow week? $SLEEPY_BOI"
else
  if $confirm "Commit and push to github? (Y/n)"; then
    git add --all .
    git commit -m "backup script"
    git push origin master
  fi
fi

date > $LAST_RAN_FILE
