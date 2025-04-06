{ pkgs, lib, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  environment = {
    etc = {
      terminfo = {
        source = "${pkgs.ncurses}/share/terminfo";
      };
    };

    systemPackages = with pkgs; [
      vim
      mtr
      ncurses
      # make derivation of tailscale, to include nettools dependency
      # (tailscale.overrideAttrs (oldAttrs: {
      #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ nettools ];
      #
      #   postFixup = ''
      #     wrapProgram $out/bin/tailscale --prefix PATH : ${nettools}/bin
      #   '';
      # }))
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "left";
    };
    finder.AppleShowAllExtensions = true;
    screencapture.location = "~/Pictures/screenshots";
    NSGlobalDomain = {
      InitialKeyRepeat = 14; #units are 15ms, 500ms
      KeyRepeat = 2; #units are 15ms, 15ms
      NSDocumentSaveNewDocumentsToCloud = false;
    };
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  # services.tailscale.enable = true;

  users.users.iwanp = {
    name = "iwanp";
    home = "/Users/iwanp";
  };
  home-manager.backupFileExtension = "backup";

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      mouse_follows_focus = "on";
      focus_follows_mouse = "off";
      window_origin_display = "default";
      window_shadow = "float";
      window_animation_duration = "0.25";
      window_animation_easing = "ease_out_quint";
      window_opacity_duration = "0.2";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.93";
      window_opacity = "on";
      insert_feedback_color = "0xffee5396";
      split_ratio = "0.62";
      split_type = "auto";
      auto_balance = "off";
      layout = "bsp";
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      window_gap = "10";
      top_padding = "8";
      bottom_padding = "8";
      left_padding = "8";
      right_padding = "8";
    };
    extraConfig = ''
      yabai -m rule --add app="Rider" manage=off
      yabai -m rule --add app="Rider" title="~/dev/" manage=on

      yabai -m rule --add app='System Settings' manage=off
      yabai -m signal --add event=dock_did_restart action='sudo yabai --load-sa'
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      cmd - return : open /Applications/Ghostty.app
      cmd - d : open /Applications/Firefox.app

      # Navigation
      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east
      shift + cmd - h : yabai -m window --swap west
      shift + cmd - j : yabai -m window --swap south
      shift + cmd - k : yabai -m window --swap north
      shift + cmd - l : yabai -m window --swap east

      alt + shift - h : yabai -m window --resize left:-55:0;
      alt + shift - j : yabai -m window --resize bottom:0:55;
      alt + shift - k : yabai -m window --resize top:0:-55;
      alt + shift - l : yabai -m window --resize right:55:0;

      shift + cmd - f : yabai -m window --toggle zoom-fullscreen
      alt + shift - f : yabai -m window --toggle native-fullscreen

      # Float / Unfloat window
      cmd + alt - space : \
          yabai -m window --toggle float; \
          yabai -m window --toggle border

      # Restart Yabai
      # shift + ctrl + cmd - r : \
      #     /usr/bin/env osascript <<< \
      #         "display notification \"Restarting Yabai\" with title \"Yabai\""; \
      #     yabai --restart-service

      # Focus space
      #cmd - 1 : yabai -m display --focus $(yabai -m query --spaces --space 1 | jq .display) && yabai -m space --focus 1
      #cmd - 2 : yabai -m display --focus $(yabai -m query --spaces --space 2 | jq .display) && yabai -m space --focus 2
      #cmd - 3 : yabai -m display --focus $(yabai -m query --spaces --space 3 | jq .display) && yabai -m space --focus 3
      #cmd - 4 : yabai -m display --focus $(yabai -m query --spaces --space 4 | jq .display) && yabai -m space --focus 4
      #cmd - 5 : yabai -m display --focus $(yabai -m query --spaces --space 5 | jq .display) && yabai -m space --focus 5
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5

      # Move window to space
      shift + cmd - 1 : yabai -m window --space 1
      shift + cmd - 2 : yabai -m window --space 2
      shift + cmd - 3 : yabai -m window --space 3
      shift + cmd - 4 : yabai -m window --space 4
      shift + cmd - 5 : yabai -m window --space 5

      # Cycle spaces by mission-control index if one exists, otherwise focus the first/last space
      cmd - tab : yabai -m space --focus next || yabai -m space --focus first
      shift + cmd - tab : yabai -m space --focus prev || yabai -m space --focus last
    '';
  };


  homebrew = {
    enable = true;
    global = {
      brewfile = true;
    };
    taps = [
      "homebrew/bundle"
    ];
    brews = [
      "mkcert"
      "nss"
      "azcopy"
    ];
    casks = [
      "tower"
      "loom"
      "missive"
      "tableplus"
      "spaceman"
      "jordanbaird-ice"
      "ghostty"
      "google-chrome"
      "firefox"
      "raycast"
      "spotify"
      "slack"
    ];
    masApps = { };
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
  };

  fonts = {
    packages = [
      pkgs.ibm-plex
      pkgs.nerd-fonts.blex-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.victor-mono
      pkgs.nerd-fonts.zed-mono
    ];
  };


  nix.gc = {
    automatic = true;
    options = "--delete-older-than 2d";
    interval = {
      Hour = 5;
      Minute = 0;
    };
  };

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
  };

  nix.package = lib.mkForce pkgs.nixVersions.latest;

  nix.settings.trusted-users = [
    "root"
    "iwanp"
  ];

  nix.settings = {
    use-xdg-base-directories = true;
    experimental-features = "nix-command flakes";
    auto-optimise-store = false;

    allowed-users = [ "@wheel" "nix-serve" ];
    always-allow-substitutes = true;
    substituters = [
      "https://cache.nixos.org/"
    ];
  };
}
