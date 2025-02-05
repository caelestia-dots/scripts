#!/bin/fish

. (dirname (status filename))/util.fish

function confirm-copy -a from to
    if test -e $to
        read -l -p "input '$(realpath $to) already exists. Overwrite? [y/N] ' -n" confirm
        test "$confirm" = 'y' -o "$confirm" = 'Y' && log 'Continuing.' || return
    end
    cp $from $to
end

install-deps git

set -l dist $CONFIG/vscode

# Clone repo
confirm-overwrite $dist
git clone 'https://github.com/caelestia-dots/vscode.git' $dist

# Install settings
for prog in 'Code' 'Code - OSS' 'VSCodium'
    set -l conf $CONFIG/../$prog
    if test -d $conf
        confirm-copy $dist/settings.json $conf/User/settings.json
        confirm-copy $dist/keybindings.json $conf/User/keybindings.json
    end
end

# Install extension
for prog in code code-insiders codium
    if which $prog &> /dev/null
        log "Installing extensions for '$prog'"
        $prog --install-extension catppuccin.catppuccin-vsc
        $prog --install-extension $dist/caelestia-vscode-integration/caelestia-vscode-integration-0.0.1.vsix
    end
end

log 'Done.'
