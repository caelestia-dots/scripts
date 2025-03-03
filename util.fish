function _out -a colour level text
    set_color $colour
    # Pass arguments other than text to echo
    echo $argv[4..] -- ":: [$level] $text"
    set_color normal
end

function log -a text
    _out cyan LOG $text $argv[2..]
end

function warn -a text
    _out yellow WARN $text $argv[2..]
end

function error -a text
    _out red ERROR $text $argv[2..]
    return 1
end

function input -a text
    _out blue INPUT $text $argv[2..]
end

set -q XDG_DATA_HOME && set C_DATA $XDG_DATA_HOME/caelestia || set C_DATA $HOME/.local/share/caelestia
set -q XDG_STATE_HOME && set C_STATE $XDG_STATE_HOME/caelestia || set C_STATE $HOME/.local/state/caelestia
set -q XDG_CACHE_HOME && set C_CACHE $XDG_CACHE_HOME/caelestia || set C_CACHE $HOME/.cache/caelestia
set -q XDG_CONFIG_HOME && set CONFIG $XDG_CONFIG_HOME || set CONFIG $HOME/.config

mkdir -p $C_DATA
mkdir -p $C_STATE
mkdir -p $C_CACHE
