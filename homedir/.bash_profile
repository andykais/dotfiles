#seves colored terminal code
#PS1='$(if [ $? -eq 0 ]; then echo "\[\033[01;32m\]:)"; else echo "\[\033[31m\]:("; fi) ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u : \[\033[00;37m\]$(echo $(pwd) | grep -o "/" | wc -l)/$(basename $(pwd))\[\033[00m\] - '
PS1='$(if [ $? -eq 0 ]; then echo "\[\033[32m\]:)"; else echo "\[\033[31m\]:("; fi) ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u : \[\033[01;34m\]$(echo $(pwd) | grep -o "/" | wc -l)/$(basename $(pwd))\[\033[00m\] - '


[[ -f ~/.profile ]] && . ~/.profile
