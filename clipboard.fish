#!/bin/fish

set chosen_item (cliphist list | fuzzel --dmenu)
test -n "$chosen_item" && echo "$chosen_item" | cliphist decode | wl-copy