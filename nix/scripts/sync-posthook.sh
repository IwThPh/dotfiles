#!/bin/sh

# hyprland
pgrep Hyprland &> /dev/null && echo "Reloading hyprland" && hyprctl reload &> /dev/null && laptop-lid-check &> /dev/null;
pgrep .waybar-wrapped &> /dev/null && echo "Restarting waybar" && killall waybar && echo "Running waybar" && waybar &> /dev/null & disown;
pgrep fnott &> /dev/null && echo "Restarting fnott" && killall fnott && echo "Running fnott" && fnott &> /dev/null & disown;
pgrep hyprpaper &> /dev/null && echo "Reapplying background via hyprpaper" && killall hyprpaper && echo "Running hyprpaper" && hyprpaper &> /dev/null & disown;
