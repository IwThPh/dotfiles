#!/usr/bin/env bash

SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | fuzzel --dmenu -l 7 -p "Power Menu: ")"

case $SELECTION in
	*"Lock")
		hyprlock -c ~/.config/hypr/hyprlock.conf;;
	*"Suspend")
		systemctl suspend;;
	*"Log out")
		hyprctl dispatch exit;;
	*"Reboot")
		systemctl reboot;;
	*"Reboot to UEFI")
		systemctl reboot --firmware-setup;;
	*"Shutdown")
		systemctl poweroff;;
esac
