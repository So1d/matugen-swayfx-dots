#!/bin/bash

KEYBINDS=$(swaymsg -t get_config | \
    jq -r '.config' | \
    grep '^\s*bindsym' | \
    sed -E 's/^\s*bindsym (--no-warn | --release )?//')


echo "$KEYBINDS" | fuzzel --dmenu --prompt "Atalhos do Sway:" --lines 20 --width 60
