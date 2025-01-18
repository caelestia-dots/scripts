set -l seen '__fish_seen_subcommand_from'
set -l has_opt '__fish_contains_opt'
set -l commands help shell toggle workspace-action scheme screenshot clipboard clipboard-delete emoji-picker wallpaper pip
set -l not_seen "not $seen $commands"

# Disable file completions
complete -c caelestia -f

# Subcommands
complete -c caelestia -n $not_seen -a 'help' -d 'Show help'
complete -c caelestia -n $not_seen -a 'shell' -d 'Start the shell or message it'
complete -c caelestia -n $not_seen -a 'toggle' -d 'Toggle a special workspace'
complete -c caelestia -n $not_seen -a 'workspace-action' -d 'Exec a dispatcher in the current group'
complete -c caelestia -n $not_seen -a 'scheme' -d 'Switch the current colour scheme'
complete -c caelestia -n $not_seen -a 'screenshot' -d 'Take a screenshot'
complete -c caelestia -n $not_seen -a 'clipboard' -d 'Open clipboard history'
complete -c caelestia -n $not_seen -a 'clipboard-delete' -d 'Delete from clipboard history'
complete -c caelestia -n $not_seen -a 'emoji-picker' -d 'Open the emoji picker'
complete -c caelestia -n $not_seen -a 'wallpaper' -d 'Change the wallpaper'
complete -c caelestia -n $not_seen -a 'pip' -d 'Picture in picture utilities'

# Shell
set -l commands quit reload-css show brightness media
set -l not_seen "$seen shell && not $seen $commands"
complete -c caelestia -n $not_seen -a 'quit' -d 'Quit the shell'
complete -c caelestia -n $not_seen -a 'reload-css' -d 'Reload shell styles'
complete -c caelestia -n $not_seen -a 'show' -d 'Show a window'
complete -c caelestia -n $not_seen -a 'media' -d 'Media commands'
complete -c caelestia -n $not_seen -a 'brightness' -d 'Change brightness'

set -l commands play-pause next previous stop
set -l not_seen "$seen shell && $seen media && not $seen $commands"
complete -c caelestia -n $not_seen -a 'play-pause' -d 'Play/pause media'
complete -c caelestia -n $not_seen -a 'next' -d 'Skip to next song'
complete -c caelestia -n $not_seen -a 'previous' -d 'Go to previous song'
complete -c caelestia -n $not_seen -a 'stop' -d 'Stop media'

# Toggles
set -l commands communication music specialws sysmon
complete -c caelestia -n "$seen toggle && not $seen $commands" -a "$commands"

# Workspace action
set -l commands workspace workspacegroup movetoworkspace movetoworkspacegroup
complete -c caelestia -n "$seen workspace-action && not $seen $commands" -a "$commands"

# Scheme
set -l commands mocha macchiato frappe latte
complete -c caelestia -n "$seen scheme && not $seen $commands" -a "$commands"

# Wallpaper
set -l not_seen "$seen wallpaper && not $has_opt -s h help && not $has_opt -s f file && not $has_opt -s d directory"
complete -c caelestia -n $not_seen -s 'h' -l 'help' -d 'Show help'
complete -c caelestia -n $not_seen -s 'f' -l 'file' -d 'The file to switch to' -r
complete -c caelestia -n $not_seen -s 'd' -l 'directory' -d 'The directory to select from' -r

complete -c caelestia -n "$seen wallpaper && $has_opt -s f file" -F
complete -c caelestia -n "$seen wallpaper && $has_opt -s d directory" -F

set -l not_seen "$seen wallpaper && $has_opt -s d directory && not $has_opt -s F no-filter && not $has_opt -s t threshold"
complete -c caelestia -n $not_seen -s 'F' -l 'no-filter' -d 'Do not filter by size'
complete -c caelestia -n $not_seen -s 't' -l 'threshold' -d 'The threshold to filter by' -r

# Pip
set -l not_seen "$seen pip && not $has_opt -s h help && not $has_opt -s d daemon"
complete -c caelestia -n $not_seen -s 'h' -l 'help' -d 'Show help'
complete -c caelestia -n $not_seen -s 'd' -l 'daemon' -d 'Start in daemon mode'
