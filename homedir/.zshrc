# xterm transparency
[ -n "$XTERM_VERSION" ] && transset-df --max 0.90 --id "$WINDOWID" >/dev/null

# User configuration
COMPLETION_WAITING_DOTS="true" # display red dots whilst waiting for completion.
DISABLE_AUTO_UPDATE="true" # disable bi-weekly auto-update checks.
ulimit -n 2048

# plugins with zgen
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
  zgen oh-my-zsh
  # zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/z
  zgen oh-my-zsh plugins/docker
  zgen oh-my-zsh plugins/dirhistory
  zgen oh-my-zsh themes/agnoster
  zgen oh-my-zsh plugins/colored-man-pages
  # mkdir ~/.zgen/robbyrussell/oh-my-zsh-master/custom/plugins/deno
  # deno completions zsh > ~/.zgen/robbyrussell/oh-my-zsh-master/custom/plugins/deno/_deno
  zgen oh-my-zsh custom/plugins/deno
  zgen load zdharma/fast-syntax-highlighting # supposedly faster than zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-completions src
  zgen save # generate the init script from plugins above
fi

prompt_ranger() {
  if [[ -n $RANGER_LEVEL ]]
  then
    echo -n "(ranger-$RANGER_LEVEL)"
  fi
}


build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_ranger
  prompt_context
  prompt_dir
  prompt_end
  # git symbolic-ref --short HEAD
  # git-radar --zsh --fetch
}

source ~/.bashrc
