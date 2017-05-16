# User configs
This repo contains all the config files in linux that I have touched

# How to Backup
- occasionally do a `gstat` on the home dir to check for config changes (in future set up
  cron job)
- run `backup.sh` to backup package managers (pacman, npm/yarn, RubyGems, apm, pip, tlmgr)

# Fonts
```bash
# Powerline fonts
git clone git@github.com:powerline/fonts.git 
./fonts/install.sh

# Adobe Source Code Pro (not necessary its in powerline)
npm install git://github.com/adobe-fonts/source-code-pro.git#release
cp node_modules/TTF/* ~/.local/share/fonts
fc-cache -fv
```


# Appearance
gtk themes
- lxappearance
- gtk-chtheme
- qt4-qtconfig

### OS Specific
#### Mint
- `.config/ranger/scope.sh` sets highlight to `/usr/bin/highlight`
- make sure terminal uses login script

