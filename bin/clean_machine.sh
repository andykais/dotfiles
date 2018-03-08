#!/bin/bash

. ~/bin/helpers/func_confirm.sh

tee_command() {
  (set -x; "$@")
}

confirm 'clean yarn cache?' \
  && tee_command yarn cache clean

confirm 'clean pip cache?' \
  && tee_command rm -rf ~/.cache/pip

confirm 'clean pacman cache?' \
  && tee_command sudo pacman -Sc

confirm 'remove non-running docker containers?' \
  && tee_command docker rm $(echo $(docker ps -q --no-trunc) $(docker ps -a -q --no-trunc) | sed 's|\s|\n|g'  | sort | uniq -u)

confirm 'remove dangling docker images?' \
  && tee_command docker rmi $(docker images -f dangling=true -q)

confirm 'remove un-tagged docker images?' \
  && tee_command docker rmi $(docker images | grep "[a-z\/0-9]*\s*<none>" | awk "{print \$3}")

confirm 'remove dangling docker volumes?' \
  && tee_command docker volume rm $(docker volume ls -f dangling=true -q)
