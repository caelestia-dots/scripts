#!/bin/fish

set -l src (dirname (realpath (status filename)))

. $src/util.fish

if test "$argv[1]" = shell
    # Start shell if no args
    if test -z "$argv[2..]"
        $C_DATA/shell/run.fish
    else
        if contains -- 'caelestia' (astal -l)
            log "Sent command '$argv[2..]' to shell"
            astal -i caelestia $argv[2..]
        else
            warn 'Shell unavailable'
        end
    end
    exit
end

if test "$argv[1]" = toggle
    set -l valid_toggles communication music sysmon specialws todo
    contains -- "$argv[2]" $valid_toggles && $src/toggles/$argv[2].fish || error "Invalid toggle: $argv[2]"
    exit
end

if test "$argv[1]" = workspace-action
    $src/workspace-action.sh $argv[2..]
    exit
end

if test "$argv[1]" = scheme
    $src/scheme/main.fish $argv[2..]
    exit
end

if test "$argv[1]" = install
    set -l valid_modules discord fish foot fuzzel hypr safeeyes scripts shell gtk vscode
    if test "$argv[2]" = all
        for module in $valid_modules
            $src/install/$module.fish $argv[3..]
        end
    else
        contains -- "$argv[2]" $valid_modules && $src/install/$argv[2].fish $argv[3..] || error "Invalid module: $argv[2]"
    end
    exit
end

set -l valid_subcommands screenshot record clipboard clipboard-delete emoji-picker wallpaper pip

if contains -- "$argv[1]" $valid_subcommands
    $src/$argv[1].fish $argv[2..]
    exit
end

test "$argv[1]" != help && error "Unknown command: $argv[1]"

echo 'Usage: caelestia COMMAND [ ...args ]'
echo
echo 'COMMAND := help | install | shell | toggle | workspace-action | scheme | screenshot | record | clipboard | clipboard-delete | emoji-picker | wallpaper | pip'
echo
echo '  help: show this help message'
echo '  install: install a module'
echo '  shell: start the shell or message it'
echo '  toggle: toggle a special workspace'
echo '  workspace-action: execute a Hyprland workspace dispatcher in the current group'
echo '  scheme: change the current colour scheme'
echo '  screenshot: take a screenshot'
echo '  record: take a screen recording'
echo '  clipboard: open clipboard history'
echo '  clipboard-delete: delete an item from clipboard history'
echo '  emoji-picker: open the emoji picker'
echo '  wallpaper: change the wallpaper'
echo '  pip: move the focused window into picture in picture mode or start the pip daemon'

# Set exit status
test "$argv[1]" = help
exit
