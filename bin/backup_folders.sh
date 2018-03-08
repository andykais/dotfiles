#!/bin/bash

# FILENAME=folder_backup.tar.gz
# BACKUP_SRC=$HOME/
# BACKUP_DEST=/mnt
BACKUP_SRC=$1
BACKUP_FILENAME=music.tar.gz
BACKUP_DEST=/mnt2/backups/backups/$BACKUP_FILENAME

tar --delete --file=$BACKUP_DEST $(find -type f $BACKUP_SRC)
tar --update --gzip --verbose --preserve-permissions --file=$BACKUP_DEST --backup=none $BACKUP_SRC
