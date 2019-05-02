# Dotfiles
This repo contains all the config files in linux that I have touched

## Setup
```bash
# clone this repository into the ~/.dotfiles (or wherever you want)
git clone git@github.com:andykais/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
# optionally, you can perform a dry run before installing
# if you wish to see what it will do
DRY_RUN=true ./install.sh
```

## How to Backup
Run `backup.sh` to commit files to the repo. It will commit any changes to the config files. It will also
commit installed packages from `pacman`, `npm`/`yarn`, `gem`, `apm`, `pip2`/`pip3`, `tlmgr`. If you wish to
automate the backup process, you could create a cron job to periodically run the script.

```bash
./backup.sh
```

## Configuration Outside of Dotfiles
## Appearance
gtk themes
- lxappearance
- gtk-chtheme
- qt4-qtconfig

### OS Specific
#### Mint
- `.config/ranger/scope.sh` sets highlight to `/usr/bin/highlight`
- make sure terminal uses login script

