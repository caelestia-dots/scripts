#!/bin/fish

. (dirname (status filename))/util.fish

install-deps git dart-sass libastal-gjs-git libastal-meta npm curl libnotify ttf-material-symbols-variable-git ttf-jetbrains-mono-nerd ttf-rubik-vf pacman-contrib
install-optional-deps 'uwsm (for systems using uwsm)' 'yay (AUR package management)' 'fd (launcher file search)' 'wl-clipboard (clipboard support)' 'foot (opening stuff in terminal)'

set -l shell $C_DATA/shell

# Update/Clone repo
update-repo shell $shell

cd $shell || exit
npm install

log 'Done.'
