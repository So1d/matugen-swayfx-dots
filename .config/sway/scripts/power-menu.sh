#!/bin/bash


OPTIONS=" Lock\n Logout\n Suspend\n Reboot\n Shutdown"

SELECTED=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt "System:" --lines 5 --width 11)


case "$SELECTED" in
    " Lock")
        swaylock -C /home/machado/.config/swaylock/swaylock.conf
        ;;
    " Logout")
        swaymsg exit
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
esac
