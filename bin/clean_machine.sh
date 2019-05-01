#!/bin/bash

. ~/bin/helpers/func_confirm.sh

human_readable() {
  local bytes=$1
  echo $bytes | numfmt --to=iec --suffix=B --from-unit=1024
}
# human_readable() {
# NUMBER=$1
# for DESIG in B K M G T P
# do
#    [ $NUMBER -lt 1000 ] && break
#    NUMBER=$((NUMBER / 1024))
# done
# printf "%d%s\n" $NUMBER $DESIG
# }

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

confirm 'clean yarn cache?' \
  && tee_command yarn cache clean

confirm 'clean npm cache?' \
  && tee_command npm cache clean --force

confirm 'clean pip cache?' \
  && tee_command rm -rf ~/.cache/pip

confirm 'clean pipenv cache?' \
  && tee_command rm -rf ~/.cache/pipenv

confirm 'clean sbt cache?' \
  && tee_command rm -rf ~/.ivy2/cache

confirm 'clean pacman cache?' \
  && tee_command sudo pacman -Scc

confirm 'docker system prune' \
  && tee_command docker system prune

confirm 'docker volume prune' \
  && tee_command docker volume prune

confirm 'clean spotify cache?' \
  && tee_command rm -r ~/.cache/spotify

# confirm 'remove non-running docker containers?' \
  # && tee_command docker rm $(echo $(docker ps -q --no-trunc) $(docker ps -a -q --no-trunc) | sed 's|\s|\n|g'  | sort | uniq -u)

# confirm 'remove dangling docker images?' \
  # && tee_command docker rmi $(docker images -f dangling=true -q)

# confirm 'remove un-tagged docker images?' \
  # && tee_command docker rmi $(docker images | grep "[a-z\/0-9]*\s*<none>" | awk "{print \$3}")

# confirm 'remove dangling docker volumes?' \
  # && tee_command docker volume rm $(docker volume ls -f dangling=true -q)
