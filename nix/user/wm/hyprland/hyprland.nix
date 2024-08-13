{ inputs, config, lib, pkgs, userSettings, ... }:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ../../apps/alacritty.nix
    (import ../../apps/networkmanager-dmenu.nix { dmenu_command = "fuzzel -d"; inherit config lib pkgs userSettings; })
  ];

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 28;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [ 
      inputs.hycov.packages.${pkgs.system}.hycov
    ];
    settings = { };
    extraConfig = ''
      exec-once = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = hyprctl setcursor '' + config.gtk.cursorTheme.name + " " + builtins.toString config.gtk.cursorTheme.size + ''

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = GDK_BACKEND,wayland,x11,*
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = CLUTTER_BACKEND,wayland

      env = GDK_SCALE,1
      env = QT_ENABLE_HIGHDPI_SCALING,1

      exec-once = nm-applet
      exec-once = blueman-applet
      exec-once = waybar

      exec-once = hypridle 
      exec-once = sleep 5 && libinput-gestures
      exec-once = hyprpaper

      exec-once = [workspace 1 silent] alacritty
      exec-once = [workspace 2 silent] vivaldi
      exec-once = [workspace 5 silent] spotify
      exec-once = [workspace 5 silent] slack

      # monitor = eDP-1,preferred,3440x0,2
      # monitor = DP-1,3440x1440@164.90,0x0,1,bitdepth,10
      monitor = eDP-1,preferred,auto,2
      monitor = ,preferred,auto,1

      bezier = wind, 0.05, 0.9, 0.1, 1.0
      bezier = winIn, 0.1, 1.1, 0.1, 1.0
      bezier = winOut, 0.3, -0.3, 0, 1
      bezier = liner, 1, 1, 1, 1
      bezier = linear, 0.0, 0.0, 1.0, 1.0

      animations {
           enabled = yes
           animation = windowsIn, 1, 7, winIn, popin
           animation = windowsOut, 1, 7, winOut, popin
           animation = windowsMove, 1, 5, wind, slide
           animation = border, 1, 10, default
           animation = borderangle, 1, 100, linear, loop
           animation = fade, 1, 10, default
           animation = workspaces, 1, 5, wind
           animation = windows, 1, 6, wind, slide
      }

      general {
        layout = dwindle
        border_size = 2
      }

      dwindle {
        preserve_split = true
        smart_split = false
        force_split = 2
        default_split_ratio = 1.2
      }

      plugin {
        hycov {
          overview_gappo = 60 # gaps width from screen edge
          overview_gappi = 24 # gaps width from clients
          enable_hotarea = 0 # enable mouse cursor hotarea, when cursor enter hotarea, it will toggle overview
          enable_click_action = 1 # enable mouse left button jump and right button kill in overview mode
          swipe_fingers = 3 # finger number of gesture,move any directory
          move_focus_distance = 100 # distance for movefocus,only can use 3 finger to move
          enable_gesture = 0 # enable gesture
          auto_exit = 1 # enable auto exit when no client in overview
          auto_fullscreen = 0 # auto make active window maximize after exit overview
          only_active_workspace = 0 # only overview the active workspace
          only_active_monitor = 0 # only overview the active monitor
          enable_alt_release_exit = 0 # alt switch mode arg,see readme for detail
          alt_replace_key = Super_L # alt switch mode arg,see readme for detail
          alt_toggle_auto_next = 0 # auto focus next window when toggle overview in alt switch mode
          click_in_cursor = 1 # when click to jump,the target window is find by cursor, not the current foucus window.
          height_of_titlebar = 0 # height deviation of title bar height
          show_special = 0 # show windows in special workspace in overview.
        }
      }

      bind=SUPER,RETURN,exec,'' + userSettings.term + ''

      bind=SUPER,A,exec,'' + userSettings.spawnEditor + ''

      bind=SUPER,S,exec,'' + userSettings.browser + ''

      bind=SUPERSHIFT,P,exec,grim -g "$(slurp -d)" - | wl-copy
      bind=,Print,exec,grim -g "$(slurp -d)" - | wl-copy

      bind=SUPER,SPACE,exec,fuzzel
      bind=SUPERSHIFT,F,fullscreen,0
      bind=SUPER,Y,workspaceopt,allfloat
      bind=ALT,TAB,cyclenext
      bind=ALT,TAB,bringactivetotop
      bind=ALTSHIFT,TAB,cyclenext,prev
      bind=ALTSHIFT,TAB,bringactivetotop
      bind=SUPER,TAB,hycov:toggleoverview
      bind=SUPER,left,hycov:movefocus,leftcross
      bind=SUPER,right,hycov:movefocus,rightcross
      bind=SUPER,up,hycov:movefocus,upcross
      bind=SUPER,down,hycov:movefocus,downcross
      bind=SUPER,V,exec,wl-copy $(wl-paste | tr '\n' ' ')
      bind=SUPERSHIFT,T,exec,screenshot-ocr
      bind=CTRLALT,Delete,exec,hyprctl kill
      bind=SUPERSHIFT,K,exec,hyprctl kill

      bind=SUPER,Q,killactive
      bind=SUPERSHIFT,Q,exit
      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow
      bind=SUPER,T,togglefloating

      bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,2880x1800@90,0x0,1.25"
      bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
      bind=SUPERCTRL,L,exec,loginctl lock-session

      bind= ,xf86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind= ,xf86audioraisevolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bind= ,xf86audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind= ,xf86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      # bind= ,xf86Display, exec, todo
      # bind= ,xf86WLAN, exec, already bound via applet?
      # bind= ,xf86KbdBrightnessDown, exec, todo
      # bind= ,xf86KbdBrightnessUp, exec, todo
      # bind= ,xf86MonBrightnessDown, exec, todo
      # bind= ,xf86MonBrightnessUp, exec, todo
      # bind= ,XF86NotificationCenter, exec, todo
      # bind= ,XF86PickupPhone, exec, todo
      # bind= ,XF86HangupPhone, exec, todo
      # bind= ,XF86Favorites, exec, todo
      bind= ,XF86SelectiveScreenshot, exec, screenshot-ocr

      bind=SUPER,H,movefocus,l
      bind=SUPER,J,movefocus,d
      bind=SUPER,K,movefocus,u
      bind=SUPER,L,movefocus,r

      bind=SUPERSHIFT,H,movewindow,l
      bind=SUPERSHIFT,J,movewindow,d
      bind=SUPERSHIFT,K,movewindow,u
      bind=SUPERSHIFT,L,movewindow,r

      bind=SUPER,1,focusworkspaceoncurrentmonitor,1
      bind=SUPER,2,focusworkspaceoncurrentmonitor,2
      bind=SUPER,3,focusworkspaceoncurrentmonitor,3
      bind=SUPER,4,focusworkspaceoncurrentmonitor,4
      bind=SUPER,5,focusworkspaceoncurrentmonitor,5
      bind=SUPER,6,focusworkspaceoncurrentmonitor,6
      bind=SUPER,7,focusworkspaceoncurrentmonitor,7
      bind=SUPER,8,focusworkspaceoncurrentmonitor,8
      bind=SUPER,9,focusworkspaceoncurrentmonitor,9
      bind=SUPER,0,focusworkspaceoncurrentmonitor,10

      bind=SUPERSHIFT,1,movetoworkspace,1
      bind=SUPERSHIFT,2,movetoworkspace,2
      bind=SUPERSHIFT,3,movetoworkspace,3
      bind=SUPERSHIFT,4,movetoworkspace,4
      bind=SUPERSHIFT,5,movetoworkspace,5
      bind=SUPERSHIFT,6,movetoworkspace,6
      bind=SUPERSHIFT,7,movetoworkspace,7
      bind=SUPERSHIFT,8,movetoworkspace,8
      bind=SUPERSHIFT,9,movetoworkspace,9
      bind=SUPERSHIFT,0,movetoworkspace,10

      windowrulev2 = float,class:^(Element)$
      windowrulev2 = size 100% 100%,class:^(Element)$
      windowrulev2 = center,class:^(Element)$

      # windowrulev2=nofocus,class:^jetbrains-(?!toolbox),floating:1,title:^win\d+$

      $savetodisk = title:^(Save to Disk)$
      windowrulev2 = float,$savetodisk
      windowrulev2 = size 70% 75%,$savetodisk
      windowrulev2 = center,$savetodisk

      bind=SUPER,I,exec,networkmanager_dmenu
      bind=SUPER,ESCAPE,exec,nwg-bar
      # bind=SUPER,P,exec,keepmenu
      # bind=SUPERSHIFT,P,exec,hyprprofile-dmenu

      xwayland {
        force_zero_scaling = true
      }

      binds {
        movefocus_cycles_fullscreen = false
      }

      input {
        kb_layout=us
        kb_options=ctrl:nocaps
        repeat_delay=350
        repeat_rate=50
        accel_profile=adaptive
        follow_mouse=2
        float_switch_override_focus=0
      }

      misc {
        disable_hyprland_logo = true
        mouse_move_enables_dpms = false
      }

      decoration {
        rounding = 3
        blur {
          enabled = true
          size = 5
          passes = 2
          ignore_opacity = true
          contrast = 1.17
          brightness = '' + (if (config.stylix.polarity == "dark") then "0.8" else "1.25") + ''

          xray = true
        }
      }
    '';
    xwayland = { enable = true; };
    systemd.enable = true;
  };

  home.packages = (with pkgs; [
    pcmanfm
    alacritty
    feh
    killall
    polkit_gnome
    papirus-icon-theme
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    wlr-randr
    wlr-layout-ui # Monitor UI
    wtype
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hypridle
    hyprpaper
    fnott
    fuzzel
    pinentry-gnome3
    wev
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    wlsunset
    pwvucontrol
    playerctl
    nwg-bar
    pamixer
    tesseract4
    (pkgs.writeScriptBin "screenshot-ocr" ''
      #!/bin/sh
      imgname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S).png"
      txtname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S)"
      txtfname=$txtname.txt
      grim -g "$(slurp)" $imgname;
      tesseract $imgname $txtname;
      wl-copy -n < $txtfname
    '')
    (pkgs.writeScriptBin "laptop-lid-check" ''
      #!/bin/sh
      if grep closed /proc/acpi/button/lid/LID/state &> /dev/null; then
        wlr-randr --output eDP-1 --off &> /dev/null;
      fi
    '')
    (pkgs.writeScriptBin "sct" ''
      #!/bin/sh
      killall wlsunset &> /dev/null;
      if [ $# -eq 1 ]; then
        temphigh=$(( $1 + 1 ))
        templow=$1
        wlsunset -t $templow -T $temphigh &> /dev/null &
      else
        killall wlsunset &> /dev/null;
      fi
    '')
    ] ++ (
      with pkgs-hyprland; [ hyprlock ]
    ));

    home.file.".config/libinput-gestures.conf".text = ''
      gesture swipe up 3	hyprctl dispatch hycov:toggleoverview
      '';
      # gesture swipe right 3 workspace-1	
      # gesture swipe left 3 workspace+1	

    home.file.".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
          ignore_dbus_inhibit = false
      }

      listener {
          timeout = 900 # in seconds
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 930                               # 5.5min
          on-timeout = hyprctl dispatch dpms off      # screen off when timeout has passed
          on-resume = hyprctl dispatch dpms on        # screen on when activity is detected after timeout has fired.
      }

      listener {
          timeout = 1800 # in seconds
          on-timeout = systemctl suspend
      }
    '';

    home.file.".config/hypr/hyprlock.conf".text = let 
        colors = config.lib.stylix.colors;
    in ''
      background {
        monitor =
        path = screenshot

        # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
        blur_passes = 4
        blur_size = 5
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }

      input-field {
        monitor =
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = false
        dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
        outer_color = rgb(''+colors.base07-rgb-r+'',''+colors.base07-rgb-g+'', ''+colors.base07-rgb-b+'')
        inner_color = rgb(''+colors.base00-rgb-r+'',''+colors.base00-rgb-g+'', ''+colors.base00-rgb-b+'')
        font_color = rgb(''+colors.base07-rgb-r+'',''+colors.base07-rgb-g+'', ''+colors.base07-rgb-b+'')
        fade_on_empty = true
        fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
        placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
        hide_input = false
        rounding = -1 # -1 means complete rounding (circle/oval)
        check_color = rgb(''+colors.base0A-rgb-r+'',''+colors.base0A-rgb-g+'', ''+colors.base0A-rgb-b+'')
        fail_color = rgb(''+colors.base08-rgb-r+'',''+colors.base08-rgb-g+'', ''+colors.base08-rgb-b+'')
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
        fail_transition = 300 # transition time in ms between normal outer_color and fail_color
        capslock_color = -1
        numlock_color = -1
        bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false # change color if numlock is off
        swap_font_color = false # see below

        position = 0, -20
        halign = center
        valign = center
      }

      label {
        monitor =
        text = Session Locked
        color = rgb(''+colors.base07-rgb-r+'',''+colors.base07-rgb-g+'', ''+colors.base07-rgb-b+'')
        font_size = 24
        font_family = ''+userSettings.font+''
        rotate = 0 # degrees, counter-clockwise
        position = 0, 160
        halign = center
        valign = center
      }

      label {
        monitor =
        text = $TIME
        color = rgb(''+colors.base07-rgb-r+'',''+colors.base07-rgb-g+'', ''+colors.base07-rgb-b+'')
        font_size = 20
        font_family = Intel One Mono
        rotate = 0 # degrees, counter-clockwise

        position = 0, 80
        halign = center
        valign = center
      }
    '';

    home.file.".config/waybar/config".text = ''
        // -*- mode: jsonc -*-
        {
          // "layer": "top", // Waybar at top layer
          // "position": "bottom", // Waybar position (top|bottom|left|right)
          "height": 24,
          "spacing": 4,

          "modules-left": [ "hyprland/workspaces", "hyprland/window" ],
          "modules-center": [],
          "modules-right": [ "tray", "wireplumber", "network", "cpu", "memory", "backlight", "battery", "idle_inhibitor", "clock" ],

          // Modules configuration
          "hyprland/workspaces": {
              "disable-scroll": false,
              "all-outputs": true,
              "warp-on-scroll": false
          },
          "tray": {
            // "icon-size": 21,
            "spacing": 10
          },
          "clock": {
            "timezone": "Europe/London",
            "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
            "format-alt": "{:%Y-%m-%d}"
          },
          "cpu": {
            "format": "{usage}% ",
            "tooltip": false
          },
          "memory": {
            "format": "{}% "
          },
          "backlight": {
            // "device": "acpi_video1",
            "format": "{percent}% {icon}",
            "format-icons": [
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              ""
            ]
          },
          "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
              "activated": "󰅶",
              "deactivated": "󰾪",
            },
          },
          "battery": {
            "states": {
              // "good": 95,
              "warning": 25,
              "critical": 10
            },
            "format": "{capacity}% <span font='12'>{icon}</span>",
            "format-full": "{capacity}% <span font='12'>{icon}</span>",
            "format-charging": "{capacity}% <span font='12'>󰂄</span>",
            "format-plugged": "{capacity}% <span font='12'></span>",
            "format-warning": "{capacity}% <span font='12' color='yellow'>󰁼</span>",
            "format-critical": "{capacity}% <span font='12' color='red'>󰁼</span>",
            
            // "format-alt": "{time} {icon}",
            // "format-good": "", // An empty format will hide the module
            // "format-full": "",
            "format-icons": [ "", "", "", "", "" ]
          },

          "power-profiles-daemon": {
            "format": "{icon}",
            "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
            "tooltip": true,
            "format-icons": {
              "default": "",
              "performance": "",
              "balanced": "",
              "power-saver": ""
            }
          },

          "network": {
            "format-wifi": "{essid} ",
            "format-ethernet": "Wired 󰈀",
            "tooltip-format": "{ifname} via {gwaddr} 󰈀",
            "format-linked": "{ifname} (No IP) ",
            "format-disconnected": "⚠",
            "format-alt": "{ifname}: {ipaddr}/{cidr}"
          },

          "wireplumber": {
            "format": "{volume}% {icon}",
            "format-muted": "",
            "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
            "on-click-right": "pwvucontrol",
            "format-icons": ["", "", ""]
          },

          "custom/media": {
            "format": "{icon} {}",
            "escape": true,
            "return-type": "json",
            "max-length": 40,
            "interval": 30, // Remove this if your script is endless and write in loop
            "on-click": "playerctl -p spotify play-pause",
            "on-click-right": "killall spotify",
            "smooth-scrolling-threshold": 10, // This value was tested using a trackpad, it should be lowered if using a mouse.
            "on-scroll-up" : "playerctl -p spotify next",
            "on-scroll-down" : "playerctl -p spotify previous",
            "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null",
            "exec-if": "pgrep spotify"
          }
        }
    '';

    home.file.".config/waybar/mediaplayer.py".text = ''
#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
from gi.repository.Playerctl import Player
import argparse
import logging
import sys
import signal
import gi
import json
import os
from typing import List

logger = logging.getLogger(__name__)

def signal_handler(sig, frame):
    logger.info("Received signal to stop, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    # loop.quit()
    sys.exit(0)


class PlayerManager:
    def __init__(self, selected_player=None, excluded_player=[]):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.manager.connect(
            "name-appeared", lambda *args: self.on_player_appeared(*args))
        self.manager.connect(
            "player-vanished", lambda *args: self.on_player_vanished(*args))

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)
        self.selected_player = selected_player
        self.excluded_player = excluded_player.split(',') if excluded_player else []

        self.init_players()

    def init_players(self):
        for player in self.manager.props.player_names:
            if player.name in self.excluded_player:
                continue
            if self.selected_player is not None and self.selected_player != player.name:
                logger.debug(f"{player.name} is not the filtered player, skipping it")
                continue
            self.init_player(player)

    def run(self):
        logger.info("Starting main loop")
        self.loop.run()

    def init_player(self, player):
        logger.info(f"Initialize new player: {player.name}")
        player = Playerctl.Player.new_from_name(player)
        player.connect("playback-status",
                       self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def get_players(self) -> List[Player]:
        return self.manager.props.players

    def write_output(self, text, player):
        logger.debug(f"Writing output: {text}")

        output = {"text": text,
                  "class": "custom-" + player.props.player_name,
                  "alt": player.props.player_name}

        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        sys.stdout.write("\n")
        sys.stdout.flush()

    def on_playback_status_changed(self, player, status, _=None):
        logger.debug(f"Playback status changed for player {player.props.player_name}: {status}")
        self.on_metadata_changed(player, player.props.metadata)

    def get_first_playing_player(self):
        players = self.get_players()
        logger.debug(f"Getting first playing player from {len(players)} players")
        if len(players) > 0:
            # if any are playing, show the first one that is playing
            # reverse order, so that the most recently added ones are preferred
            for player in players[::-1]:
                if player.props.status == "Playing":
                    return player
            # if none are playing, show the first one
            return players[0]
        else:
            logger.debug("No players found")
            return None

    def show_most_important_player(self):
        logger.debug("Showing most important player")
        # show the currently playing player
        # or else show the first paused player
        # or else show nothing
        current_player = self.get_first_playing_player()
        if current_player is not None:
            self.on_metadata_changed(current_player, current_player.props.metadata)
        else:    
            self.clear_output()

    def on_metadata_changed(self, player, metadata, _=None):
        logger.debug(f"Metadata changed for player {player.props.player_name}")
        player_name = player.props.player_name
        artist = player.get_artist()
        title = player.get_title()

        track_info = ""
        if player_name == "spotify" and "mpris:trackid" in metadata.keys() and ":ad:" in player.props.metadata["mpris:trackid"]:
            track_info = "Advertisement"
        elif artist is not None and title is not None:
            track_info = f"{artist} - {title}"
        else:
            track_info = title

        if track_info:
            if player.props.status == "Playing":
                track_info = " " + track_info
            else:
                track_info = " " + track_info
        # only print output if no other player is playing
        current_playing = self.get_first_playing_player()
        if current_playing is None or current_playing.props.player_name == player.props.player_name:
            self.write_output(track_info, player)
        else:
            logger.debug(f"Other player {current_playing.props.player_name} is playing, skipping")

    def on_player_appeared(self, _, player):
        logger.info(f"Player has appeared: {player.name}")
        if player.name in self.excluded_player:
            logger.debug(
                "New player appeared, but it's in exclude player list, skipping")
            return
        if player is not None and (self.selected_player is None or player.name == self.selected_player):
            self.init_player(player)
        else:
            logger.debug(
                "New player appeared, but it's not the selected player, skipping")

    def on_player_vanished(self, _, player):
        logger.info(f"Player {player.props.player_name} has vanished")
        self.show_most_important_player()

def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurrence of -v
    parser.add_argument("-v", "--verbose", action="count", default=0)

    parser.add_argument("-x", "--exclude", "- Comma-separated list of excluded player")

    # Define for which player we"re listening
    parser.add_argument("--player")

    parser.add_argument("--enable-logging", action="store_true")

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    # Initialize logging
    if arguments.enable_logging:
        logfile = os.path.join(os.path.dirname(
            os.path.realpath(__file__)), "media-player.log")
        logging.basicConfig(filename=logfile, level=logging.DEBUG,
                            format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s")

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    logger.info("Creating player manager")
    if arguments.player:
        logger.info(f"Filtering for player: {arguments.player}")
    if arguments.exclude:
        logger.info(f"Exclude player {arguments.exclude}")

    player = PlayerManager(arguments.player, arguments.exclude)
    player.run()


if __name__ == "__main__":
    main()
    '';

    programs.waybar = let 
        colors = config.lib.stylix.colors;
        bg-rgba = ''rgba('' + colors.base00-rgb-r + "," + colors.base00-rgb-g + "," + colors.base00-rgb-b + "," + ''0.55)'';
        bg-urgent = ''#''+colors.base08;
        bg-active = ''#''+colors.base0A;
        text-color = ''#''+colors.base05;
    in {
        enable = true;
        package = pkgs.waybar;
        settings = { };
        style = ''
            * {
              border: none;
              border-radius: 0;
              font-family: FontAwesome, '' + userSettings.font + '';
              font-size: 12px;
              min-height: 20px;
            }

            window#waybar {
              background-color: '' + bg-rgba + '';
              border-bottom: 3px solid rgba(0, 0, 0, 0);
              color: ''+text-color+'';
              transition-property: background-color;
              transition-duration: .5s;
            }

            window#waybar.hidden {
              opacity: 0.2;
            }

            button {
              border: none;
              border-radius: 0;
              padding: 5px;
            }

            /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
            button:hover {
              background: inherit;
              padding: 5px;
            }

            #workspaces button {
              padding: 0 5px;
              background-color: transparent;
              color: ''+text-color+'';
            }

            #workspaces button:hover {
              background: rgba(1, 1, 1, 0.2);
            }

            #workspaces button.focused {
              background-color: #64727D;
            }

            #workspaces button.urgent {
              background-color: ''+bg-urgent+'';
            }

            #workspaces button.active {
              background-color: ''+bg-active+'';
            }

            #mode {
              background-color: #64727D;
            }

            #clock,
            #battery,
            #cpu,
            #memory,
            #disk,
            #temperature,
            #backlight,
            #network,
            #pulseaudio,
            #wireplumber,
            #custom-media,
            #tray,
            #mode,
            #idle_inhibitor,
            #scratchpad,
            #power-profiles-daemon,
            #mpd {
              padding: 0 10px;
              color: ''+text-color+'';
              background-color: transparent;
            }

            #window,
            #workspaces {
              margin: 0;
            }

            /* If workspaces is the leftmost module, omit left margin
            .modules-left>widget:first-child>#workspaces {
              margin-left: 0;
            }

            .modules-right>widget:last-child>#workspaces {
              margin-right: 0;
            }

            #clock {
              background-color: #64727D;
            }

            #battery {
              background-color: #ffffff;
              color: #000000;
            }

            #battery.charging,
            #battery.plugged {
              color: #''+colors.base0B+'';
              background-color: #26A65B;
            }

            @keyframes blink {
              to {
                background-color: #ffffff;
                color: #000000;
              }
            }

            #battery.critical:not(.charging) {
              background-color: ''+bg-urgent+'';
              color: ''+text-color+'';
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: steps(12);
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }

            #power-profiles-daemon {
              padding-right: 15px;
            }

            #power-profiles-daemon.performance {
              background-color: #f53c3c;
              color: ''+text-color+'';
            }

            #power-profiles-daemon.balanced {
              background-color: #2980b9;
              color: ''+text-color+'';
            }

            #power-profiles-daemon.power-saver {
              background-color: #2ecc71;
              color: #000000;
            }

            label:focus {
              background-color: #000000;
            }

            #cpu {
            }

            #memory {
              background-color: #9b59b6;
            }

            #disk {
            }

            #backlight {
              background-color: #90b1b1;
            }

            #network {
              background-color: #2980b9;
            }

            #network.disconnected {
              background-color: #f53c3c;
            }

            #pulseaudio {
              background-color: #f1c40f;
              color: #000000;
            }

            #pulseaudio.muted {
              background-color: #90b1b1;
              color: #2a5c45;
            }

            #wireplumber {
              background-color: #fff0f5;
              color: #000000;
            }

            #wireplumber.muted {
              color: ''+bg-urgent+'';
            }

            #custom-media {
              background-color: #66cc99;
              color: #2a5c45;
              min-width: 100px;
            }

            #custom-media.custom-spotify {
              background-color: #66cc99;
            }

            #custom-media.custom-vlc {
              background-color: #ffa000;
            }

            #temperature {
              background-color: #f0932b;
            }

            #temperature.critical {
              background-color: #eb4d4b;
            }

            #tray {
              background-color: #2980b9;
            }

            #tray>.passive {
              -gtk-icon-effect: dim;
            }

            #tray>.needs-attention {
              -gtk-icon-effect: highlight;
              background-color: #eb4d4b;
            }

            #idle_inhibitor {
              background-color: #2d3436;
            }

            #idle_inhibitor.activated {
              background-color: #ecf0f1;
              color: #2d3436;
            }

            #mpd {
              background-color: #66cc99;
              color: #2a5c45;
            }

            #mpd.disconnected {
              background-color: #f53c3c;
            }

            #mpd.stopped {
              background-color: #90b1b1;
            }

            #mpd.paused {
              background-color: #51a37a;
            }

            #language {
              background: #00b093;
              color: #740864;
              padding: 0 5px;
              margin: 0 5px;
              min-width: 16px;
            }

            #keyboard-state {
              background: #97e1ad;
              color: #000000;
              padding: 0 0px;
              margin: 0 5px;
              min-width: 16px;
            }

            #keyboard-state>label {
              padding: 0 5px;
            }

            #keyboard-state>label.locked {
              background: rgba(0, 0, 0, 0.2);
            }

            #scratchpad {
              background: rgba(0, 0, 0, 0.2);
            }

            #scratchpad.empty {
              background-color: transparent;
            }

            #privacy {
              padding: 0;
            }

            #privacy-item {
              padding: 0 5px;
              color: white;
            }

            #privacy-item.screenshare {
              background-color: #cf5700;
            }

            #privacy-item.audio-in {
              background-color: #1ca000;
            }

            #privacy-item.audio-out {
              background-color: #0069d4;
            } */
        '';
    };

    services.udiskie.enable = true;
    services.udiskie.tray = "always";

    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
      main = {
        prompt = "'◉  '";
        font = userSettings.font + ":size=12";
        dpi-aware = "yes";
        terminal = userSettings.term;
        lines = 10;
        width = 45;
        horizontal-pad = 8;
        vertical-pad = 0;
        inner-pad = 0;
        line-height = 20;
      };
      colors = {
        background = config.lib.stylix.colors.base00 + "e6";
        text = config.lib.stylix.colors.base05 + "ff";
        match = config.lib.stylix.colors.base08 + "ff";
        selection = config.lib.stylix.colors.base03 + "ff";
        selection-text = config.lib.stylix.colors.base0A + "ff";
        selection-match = config.lib.stylix.colors.base0F + "ff";
        border = config.lib.stylix.colors.base05 + "e6";
      };
      border = {
        width = 2;
        radius = 3;
      };
    };

    services.fnott.enable = true;
    services.fnott.settings = {
      main = {
        anchor = "bottom-right";
        stacking-order = "top-down";
        min-width = 400;
        title-font = userSettings.font + ":size=14";
        summary-font = userSettings.font + ":size=12";
        body-font = userSettings.font + ":size=11";
        border-size = 0;
      };
      low = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base03 + "ff";
        summary-color = config.lib.stylix.colors.base03 + "ff";
        body-color = config.lib.stylix.colors.base03 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      normal = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base07 + "ff";
        summary-color = config.lib.stylix.colors.base07 + "ff";
        body-color = config.lib.stylix.colors.base07 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      critical = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base08 + "ff";
        summary-color = config.lib.stylix.colors.base08 + "ff";
        body-color = config.lib.stylix.colors.base08 + "ff";
        idle-timeout = 0;
        max-timeout = 0;
        default-timeout = 0;
      };
  };

}
