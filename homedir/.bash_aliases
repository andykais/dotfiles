# shortcuts
alias beep='echo -ne "\007"'
alias pstop='watch -n1 "ps aux --sort=-pcpu | head -n 6"'
alias psg='ps ax | ag '
alias ndone='notify-send -t 3 "CMD finished!" "in folder $(basename $PWD) with code $?"'
alias lstat='stat -c "%a %n" '
alias v='nvim'
alias l='ls -hl --group-directories-first'
alias la='ls -ahl --group-directories-first'
alias tar-preview='tar -tf'
alias run-dockerized=~/Build/prod/dockerized/cli/run-dockerized.js
alias rm-node_modules='find . -name node_modules -prune -exec rm -fr {} \'
alias list-open-fd='lsof -a -p $$ 2>/dev/null'
# alias y='youtube-dl --output "%(title)s-%(id)s.%(uploader)s.%(ext)s"' # seems to be bad at youtube downloads now
# alias y='yt-dlp --output "%(title)s-%(id)s.%(uploader)s.%(ext)s"'
# alias y='yt-dlp --output "%(webpage_url_domain)s/%(uploader)s/%(id)s/%(title)s-%(id)s.%(uploader)s.%(ext)s" --no-clean-infojson --write-comments --embed-info-json'
# alias y='yt-dlp --output "%(webpage_url_domain)s/%(uploader)s/%(id)s/%(title)s-%(id)s.%(uploader)s.%(ext)s" --no-clean-infojson --write-comments --embed-info-json --write-info-json'
alias y='yt-dlp --output "%(webpage_url_domain)s/%(uploader)s/%(id)s/%(title)s-%(id)s.%(uploader)s.%(ext)s" --no-clean-infojson --embed-info-json --write-info-json'

alias nnpm='~/.local/share/pnpm/npm'
alias npm='~/.local/share/pnpm/pnpm'
# alias npm='~/.npm-packages/bin/pnpm'
# alias npm='~/.npm-packages/bin/pnpm'

function e() {
  local archive="$@"
  local extraction_folder="${archive%.*}"
  local mimetype=$(file --mime-type --brief $archive)

  case $mimetype in
    application/x-bzip2|application/x-7z-compressed)
      7z x "$archive" -o"$extraction_folder/"
      ;;
    application/x-rar)
      unrar x "$archive" "$extraction_folder/"
      ;;
    application/zip)
      unzip "$archive" -d "$extraction_folder/"
      ;;
    application/gzip)
      mkdir -p "$extraction_folder"
      tar xzvf "$archive" -C "$extraction_folder/"
      ;;
    application/x-xz)
      mkdir -p "$extraction_folder"
      tar xf "$archive" -C "$extraction_folder/"
      ;;
    *)
      echo unknown mime type $mimetype
      return 1
      ;;
  esac
}

function font-preview() {
  xrdb ~/.Xresources \
    && xterm -e 'lsof -p $(ps -a | grep xterm | awk "{print \$1}" | head -1) | grep fonts | awk "{print \$9}";$SHELL'
}

# docker aliases
function docker-stop() {
  docker stop $(docker ps -q)
}
function docker-rmi()  {
  docker rmi $(docker images -a -q)
}
function docker-rm() {
  docker rm $(docker ps -a 2&>1 | awk 'NR>1' | grep "$1" | awk '{print $1}')
}

# git aliases
alias ga='git add --all .'
alias gaA='git add -A'
alias gc='git commit -m $1'
alias gstat='git status'
alias gd='git diff $@ --name-only'
alias gb='git branch'
function gdf() {
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git diff --name-only $current_branch $(git merge-base $current_branch master)
}

# this command can be augmented with an entry in /etc/sudoers:
# andrew ALL = (root) NOPASSWD: /home/andrew/bin/dusort.sh
alias dusort='sudo ~/bin/dusort.sh'

# ruby bundler aliases
function bjs() {
  bundle exec jekyll serve --watch
}
function bgu() {
  bundle exec guard
}

function notify() {
  while true
  do
    inotifywait -qre close_write .
  done
}

# pacman highlights your searches and already installed programs
function pacman_wrapper() {
  for arg in $@
  do
    [[ $arg =~ -*s* ]] && purpose_is_search=true
    [[ $arg =~ ^[^-] ]] && search_string=$arg
  done

  if [[ $purpose_is_search = true ]]
  then
    command pacman $@ \
      | GREP_COLORS='01;33' grep -Ei --color=always "^|$search_string" \
      | GREP_COLORS='01;31' grep -E --color=always '^|\[installed\]'
  else
    command pacman $@
  fi
}
alias pacman='pacman_wrapper'

function npm_install_local_package() {
  local cwd="$PWD" \
    && local package_folder=$1 \
    && echo "package_folder $package_folder" \
    && cd $1 \
    && local tarball=$(npm pack) \
    && echo "tarball $tarball" \
    && local fullpath="$package_folder/$tarball" \
    && cd "$cwd" \
    && npm install "$fullpath"
}
