#!/bin/bash


. ~/bin/helpers/emoticons.sh


DATE=$(date -d $(date +"%D") +"%s")
QOTD_FILE=/tmp/qotd_$DATE.json
TITLE_TAG=$(cat <<-END
   _____                .__                          .___                      
  /  _  \_______   ____ |  |__    _____    ____    __| _/______   ______  _  __
 /  /_\  \_  __ \_/ ___\|  |  \   \__  \  /    \  / __ |\_  __ \_/ __ \ \/ \/ /
/    |    \  | \/\  \___|   Y  \   / __ \|   |  \/ /_/ | |  | \/\  ___/\     / 
\____|__  /__|    \___  >___|  /  (____  /___|  /\____ | |__|    \___  >\/\_/  
        \/            \/     \/        \/     \/      \/             \/        
END
)


i3-sensible-terminal -e \
  bash -c "\
    printf '\e[34m%b\e[0m\n' '$TITLE_TAG' \
    ; ~/bin/helpers/qotd.sh $QOTD_FILE \
    && jq -r '.contents.quotes[0].quote' $QOTD_FILE \
    || echo 'Internet is down. No quote today $SAD_BOI_FACE' \
    ; $SHELL
"
