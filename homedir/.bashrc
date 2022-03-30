export EDITOR="nvim"
export VISUAL="nvim"

# quiet down tensorflow warnings
export TF_CPP_MIN_LOG_LEVEL=2

source ~/.bash_aliases
[[ -f ~/.bashrc_secrets ]] && source ~/.bashrc_secrets
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''

xset -b
setterm blength 0 
