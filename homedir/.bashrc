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

source ~/.bash_aliases
[[ -f ~/.bashrc_secrets ]] && source ~/.bashrc_secrets

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/andrew/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/andrew/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/andrew/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/andrew/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

