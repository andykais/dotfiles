#!/bin/bash


set -e


XDG_DATA_DIR=${XDG_DATA_DIR:-$HOME/.local/share}
LAST_RAN_FILE=$XDG_DATA_DIR/clean_machine_last_ran


# load helpers
confirm=~/bin/helpers/confirm.sh
days_since=~/bin/helpers/days_since.sh


human_readable() {
  local bytes=$1
  echo $bytes | numfmt --to=iec --suffix=B --from-unit=1024
}
available_space() {
  df / --output=avail | tail -1
}
difference_in_space() {
  local before=
}
tee_command() {
  local before=$(available_space)
  (set -x; "$@")
  local after=$(available_space)
  local diff=$((after - before))
  echo "Freed $(human_readable $diff) bytes"
}


if [[ -f $LAST_RAN_FILE ]]
then
  last_ran_at=$(cat $LAST_RAN_FILE)
  days_since_last_ran=$($days_since $last_ran_at)
  echo "Last ran: $last_ran_at ($days_since_last_ran days ago)"
else
  echo Running clean_machine.sh for the first time.
fi
echo

$confirm 'clean yarn cache?' \
  && tee_command yarn cache clean

$confirm 'clean npm cache?' \
  && tee_command npm cache clean --force

$confirm 'pnpm store prune?' \
  && tee_command pnpm store prune

$confirm 'clean pip cache?' \
  && tee_command rm -rf ~/.cache/pip

$confirm 'clean pipenv cache?' \
  && tee_command rm -rf ~/.cache/pipenv

$confirm 'clean sbt cache?' \
  && tee_command rm -rf ~/.ivy2/cache

$confirm 'remove orphaned os packages?' \
  && tee_command sudo pacman -Rns $(pacman -Qqtd)

$confirm 'clean pacman cache?' \
  && tee_command sudo pacman -Scc

$confirm 'clean yay cache?' \
  && tee_command yay -Scc

$confirm 'docker system prune' \
  && tee_command docker system prune

$confirm 'docker volume prune' \
  && tee_command docker volume prune

$confirm 'clean spotify cache?' \
  && tee_command rm -r ~/.cache/spotify

# confirm 'remove non-running docker containers?' \
  # && tee_command docker rm $(echo $(docker ps -q --no-trunc) $(docker ps -a -q --no-trunc) | sed 's|\s|\n|g'  | sort | uniq -u)

# confirm 'remove dangling docker images?' \
  # && tee_command docker rmi $(docker images -f dangling=true -q)

# confirm 'remove un-tagged docker images?' \
  # && tee_command docker rmi $(docker images | grep "[a-z\/0-9]*\s*<none>" | awk "{print \$3}")

# confirm 'remove dangling docker volumes?' \
  # && tee_command docker volume rm $(docker volume ls -f dangling=true -q)

date > $LAST_RAN_FILE
