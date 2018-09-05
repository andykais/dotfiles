#!/bin/bash

. ~/bin/helpers/func_confirm.sh

human_readable() {
  echo $1 | awk '
      function human(x) {
          if (x<1000) {return x} else {x/=1024}
          s="kMGTEPZY";
          while (x>=1000 && length(s)>1)
              {x/=1024; s=substr(s,2)}
          return int(x+0.5) substr(s,1,1)
      }
      {sub(/^[0-9]+/, human($1)); print}'
}
available_space() {
  df / | tail -1 | awk '{print $4}'
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
