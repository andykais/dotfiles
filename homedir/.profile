# nodejs & npm
# export NPM_PACKAGES=~/.npm-packages
export NPM_PACKAGES=~/.local/share/pnpm
unset MANPATH # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
export MANPATH=$NPM_PACKAGES/share/man:$(manpath)
export NODE_PATH=$NODE_PATH:~/.npm-packages/lib/node_modules
export PATH=$NPM_PACKAGES/bin:$PATH
# java
# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
# export PATH="$PATH:$JAVA_HOME/bin"
# rust
export PATH=$PATH:~/.cargo/bin
# personal scripts
export PATH=$PATH:~/bin
# pip install --user scripts
export PATH=$PATH:~/.local/bin
# deno installed clis
export PATH=$PATH:~/.deno/bin

export PNPM_HOME="/home/andrew/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# aseprite
# export PATH="$PATH:~/.local/share/Steam/steamapps/common/Aseprite/aseprite"
