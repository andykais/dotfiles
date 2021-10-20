export EDITOR="nvim"
export VISUAL="nvim"

# nodejs & npm
export NPM_PACKAGES=~/.npm-packages
unset MANPATH # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
export MANPATH=$NPM_PACKAGES/share/man:$(manpath)
export NODE_PATH=$NODE_PATH:~/.npm-packages/lib/node_modules
export PATH=$NPM_PACKAGES/bin:$PATH
# java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
# rust
export PATH=$PATH:~/.cargo/bin
# personal scripts
export PATH=$PATH:~/bin
# pip install --user scripts
export PATH=$PATH:~/.local/bin
# deno installed clis
export PATH=~/.deno/bin:$PATH
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
