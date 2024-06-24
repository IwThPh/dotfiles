{ inputs, config, lib, pkgs, userSettings, systemSettings, pkgs-nwg-dock-hyprland, ... }:
let
  pkgs-hyprland = pkgs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ../../apps/alacritty.nix
    (import ../../apps/networkmanager-dmenu.nix { dmenu_command = "fuzzel -d"; inherit config lib pkgs userSettings; })
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    plugins = [ ];
    settings = { };
    extraConfig = ''
      exec-once = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
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

      exec-once = nm-applet
      exec-once = blueman-applet
      exec-once = waybar

      exec-once = hypridle 
      exec-once = sleep 5 && libinput-gestures
      exec-once = hyprpaper

      monitor = eDP-1,2880x1800@90,0x0,1.25
      monitor = DP-1,3440x1440@164.90,-3440x0,1
      monitor = ,preferred,auto,1

      bezier = wind, 0.05, 0.9, 0.1, 1.0
      bezier = winIn, 0.1, 1.1, 0.1, 1.0
      bezier = winOut, 0.3, -0.3, 0, 1
      bezier = liner, 1, 1, 1, 1
      bezier = linear, 0.0, 0.0, 1.0, 1.0

      animations {
           enabled = yes
           animation = windowsIn, 1, 6, winIn, popin
           animation = windowsOut, 1, 5, winOut, popin
           animation = windowsMove, 1, 5, wind, slide
           animation = border, 1, 10, default
           animation = borderangle, 1, 100, linear, loop
           animation = fade, 1, 10, default
           animation = workspaces, 1, 5, wind
           animation = windows, 1, 6, wind, slide
      }

      general {
        layout = master
        border_size = 2
       }

       bind=SUPER,SPACE,exec,fuzzel
       bind=SUPERSHIFT,F,fullscreen,0
       bind=SUPER,Y,workspaceopt,allfloat
       bind=ALT,TAB,cyclenext
       bind=ALT,TAB,bringactivetotop
       bind=ALTSHIFT,TAB,cyclenext,prev
       bind=ALTSHIFT,TAB,bringactivetotop
       bind=SUPER,V,exec,wl-copy $(wl-paste | tr '\n' ' ')
       bind=SUPERSHIFT,T,exec,screenshot-ocr
       bind=CTRLALT,Delete,exec,hyprctl kill
       bind=SUPERSHIFT,K,exec,hyprctl kill

       bind=SUPER,RETURN,exec,'' + userSettings.term + ''

       bind=SUPER,A,exec,'' + userSettings.spawnEditor + ''

       bind=SUPER,S,exec,'' + userSettings.browser + ''

       bind=SUPER,Q,killactive
       bind=SUPERSHIFT,Q,exit
       bindm=SUPER,mouse:272,movewindow
       bindm=SUPER,mouse:273,resizewindow
       bind=SUPER,T,togglefloating

       bindl=,switch:on:Lid Switch,exec,loginctl lock-session
       bind=SUPERCTRL,L,exec,loginctl lock-session

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
       windowrulev2 = size 85% 90%,class:^(Element)$
       windowrulev2 = center,class:^(Element)$

       $savetodisk = title:^(Save to Disk)$
       windowrulev2 = float,$savetodisk
       windowrulev2 = size 70% 75%,$savetodisk
       windowrulev2 = center,$savetodisk

       $pavucontrol = class:^(pavucontrol)$
       windowrulev2 = float,$pavucontrol
       windowrulev2 = size 86% 40%,$pavucontrol
       windowrulev2 = move 50% 6%,$pavucontrol
       windowrulev2 = workspace special silent,$pavucontrol
       windowrulev2 = opacity 0.80,$pavucontrol

       bind=SUPER,I,exec,networkmanager_dmenu
       bind=SUPER,P,exec,keepmenu
       bind=SUPERSHIFT,P,exec,hyprprofile-dmenu

       xwayland {
         force_zero_scaling = true
       }

       binds {
         movefocus_cycles_fullscreen = false
       }

       input {
         kb_layout=gb
         kb_options=caps:nocaps
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
    alacritty
    feh
    killall
    polkit_gnome
    papirus-icon-theme
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    wlr-randr
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
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    wlsunset
    pavucontrol
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
    ]);

    home.file.".config/waybar/config".text = ''
        {
            "layer": "top", // Waybar at top layer
            "position": "top", // Waybar position (top|bottom|left|right)
            "margin": "9 13 -10 18",
            // Choose the order of the modules
            "modules-left": ["hyprland/workspaces", "hyprland/language", "keyboard-state", "hyprland/submap"],
            "modules-center": ["clock"],
            "modules-right": ["pulseaudio", "custom/mem", "cpu", "backlight", "battery", "tray"],


            //***************************
            //*  Modules configuration  *
            //***************************

            "hyprland/workspaces": {
                "disable-scroll": true,
            },

            "hyprland/language": {
                "format-en": "US",
                "format-ru": "RU",
            "min-length": 5,
            "tooltip": false
            },

            "keyboard-state": {
                //"numlock": true,
                "capslock": true,
                "format": "{icon} ",
                "format-icons": {
                    "locked": " ",
                    "unlocked": ""
                },
            },

            "hyprland/submap": {
                "format": "pon {}"
            },

            "clock": {
                // "timezone": "America/New_York",
                "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                "format": "{:%a, %d %b, %I:%M %p}"
            },

            "pulseaudio": {
                // "scroll-step": 1, // %, can be a float
                "reverse-scrolling": 1,
                "format": "{volume}% {icon} {format_source}",
                "format-bluetooth": "{volume}% {icon} {format_source}",
                "format-bluetooth-muted": " {icon} {format_source}",
                "format-muted": " {format_source}",
                "format-source": "{volume}% ",
                "format-source-muted": "",
                "format-icons": {
                    "headphone": "",
                    "hands-free": "",
                    "headset": "",
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": ["", "", ""]
                },
                "on-click": "pavucontrol",
                "min-length": 13,
            },

            "custom/mem": {
                "format": "{} ",
                "interval": 3,
                "exec": "free -h | awk '/Mem:/{printf $3}'",
                "tooltip": false,
            },

            "cpu": {
              "interval": 2,
              "format": "{usage}% ",
              "min-length": 6
            },

            "temperature": {
                // "thermal-zone": 2,
                // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
                "critical-threshold": 80,
                // "format-critical": "{temperatureC}°C {icon}",
                "format": "{temperatureC}°C {icon}",
                "format-icons": ["", "", "", "", ""],
                "tooltip": false,
            },

            "backlight": {
                "device": "intel_backlight",
                "format": "{percent}% {icon}",
                "format-icons": [""],
                "min-length": 7,
            },

            "battery": {
                "states": {
                    "warning": 30,
                    "critical": 15
                },
                "format": "{capacity}% {icon}",
                "format-charging": "{capacity}% ",
                "format-plugged": "{capacity}% ",
                "format-alt": "{time} {icon}",
                "format-icons": ["", "", "", "", "", "", "", "", "", ""],
            "on-update": "$HOME/.config/waybar/scripts/check_battery.sh",
            },

            "tray": {
                "icon-size": 16,
                "spacing": 0
            },
        }
    '';

    programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = {
        };
        style = ''
            * {
                border: none;
                border-radius: 0;
                /* `otf-font-awesome` is required to be installed for icons */
                font-family: FontAwesome, '' + userSettings.font + '';

                min-height: 20px;
            }

            window#waybar {
                background: transparent;
            }

            window#waybar.hidden {
                opacity: 0.2;
            }

            #workspaces {
                margin-right: 8px;
                border-radius: 10px;
                transition: none;
                background: #383c4a;
            }

            #workspaces button {
                transition: none;
                color: #7c818c;
                background: transparent;
                padding: 5px;
                font-size: 18px;
            }

            #workspaces button.persistent {
                color: #7c818c;
                font-size: 12px;
            }

            /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
            #workspaces button:hover {
                transition: none;
                box-shadow: inherit;
                text-shadow: inherit;
                border-radius: inherit;
                color: #383c4a;
                background: #7c818c;
            }

            #workspaces button.active {
                background: #4e5263;
                color: white;
                border-radius: inherit;
            }

            #language {
                padding-left: 16px;
                padding-right: 8px;
                border-radius: 10px 0px 0px 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #keyboard-state {
                margin-right: 8px;
                padding-right: 16px;
                border-radius: 0px 10px 10px 0px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #submap {
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #clock {
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px 0px 0px 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #pulseaudio {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #pulseaudio.muted {
                background-color: #90b1b1;
                color: #2a5c45;
            }

            #custom-mem {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #cpu {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #temperature {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #temperature.critical {
                background-color: #eb4d4b;
            }

            #backlight {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #battery {
                margin-right: 8px;
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background: #383c4a;
            }

            #battery.charging {
                color: #ffffff;
                background-color: #26A65B;
            }

            #battery.warning:not(.charging) {
                background-color: #ffbe61;
                color: black;
            }

            #battery.critical:not(.charging) {
                background-color: #f53c3c;
                color: #ffffff;
                animation-name: blink;
                animation-duration: 0.5s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
            }

            #tray {
                padding-left: 16px;
                padding-right: 16px;
                border-radius: 10px;
                transition: none;
                color: #ffffff;
                background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);
            }

            @keyframes blink {
                to {
                    background-color: #ffffff;
                    color: #000000;
                }
            }
          '';
  };

    services.udiskie.enable = true;
    services.udiskie.tray = "always";
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
    main = {
      font = userSettings.font + ":size=20";
      dpi-aware = "no";
      show-actions = "yes";
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
    border = {
      width = 3;
      radius = 7;
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
