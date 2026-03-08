{ pkgs, lib, config, ... }:
let
  username = config.users.users.iwanp.name;
  homeDir = config.users.users.iwanp.home;
in
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  launchd.user.envVariables = {
    PATH = "/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    DOCKER_HOST = "unix://${homeDir}/.colima/default/docker.sock";
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      mtr
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

  launchd.user.agents.syncthing = {
    serviceConfig = {
      Label = "dev.iwanp.syncthing";
      ProgramArguments = [
        "${pkgs.syncthing}/bin/syncthing"
        "serve"
        "--no-browser"
        "--no-restart"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${homeDir}/Library/Logs/syncthing.log";
      StandardErrorPath = "${homeDir}/Library/Logs/syncthing.log";
    };
  };

  system.activationScripts.postActivation.text = ''
    mkdir -p ${homeDir}/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO4m8QiaIHgVYkgEQPxBHpdebKqxmP5VIVbw3wwlxR4 iwanp-s23' > ${homeDir}/.ssh/authorized_keys
    chown ${username} ${homeDir}/.ssh/authorized_keys
    chmod 600 ${homeDir}/.ssh/authorized_keys
  '';

  services.openssh = {
    enable = true;
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      AllowUsers ${username}
      X11Forwarding no
    '';
  };

  # pf firewall rules to restrict SSH to local + Tailscale subnets
  environment.etc."pf.anchors/dev.iwanp.sshd".text = ''
    pass in quick proto tcp from 10.0.0.0/24 to any port 22
    pass in quick proto tcp from 100.64.0.0/10 to any port 22
    block in quick proto tcp from any to any port 22
  '';

  environment.etc."pf.anchors/dev.iwanp.pf.conf".text = ''
    scrub-anchor "com.apple/*"
    nat-anchor "com.apple/*"
    rdr-anchor "com.apple/*"
    dummynet-anchor "com.apple/*"
    anchor "com.apple/*"
    load anchor "com.apple" from "/etc/pf.anchors/com.apple"
    anchor "dev.iwanp.sshd"
    load anchor "dev.iwanp.sshd" from "/etc/pf.anchors/dev.iwanp.sshd"
  '';

  launchd.daemons.pf-sshd = {
    serviceConfig = {
      Label = "dev.iwanp.pf-sshd";
      RunAtLoad = true;
      ProgramArguments = [
        "/sbin/pfctl" "-e" "-f" "/etc/pf.anchors/dev.iwanp.pf.conf"
      ];
    };
  };

  system.primaryUser = "iwanp";
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
      cmd - d : open /Applications/Zen.app

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

      # Focus space
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5

      cmd - 6 : yabai -m space --focus 1
      cmd - 7 : yabai -m space --focus 2
      cmd - 8 : yabai -m space --focus 3
      cmd - 9 : yabai -m space --focus 4
      cmd - 0 : yabai -m space --focus 5

      # Move window to space
      shift + cmd - 1 : yabai -m window --space 1
      shift + cmd - 2 : yabai -m window --space 2
      shift + cmd - 3 : yabai -m window --space 3
      shift + cmd - 4 : yabai -m window --space 4
      shift + cmd - 5 : yabai -m window --space 5

      shift + cmd - 6 : yabai -m window --space 1
      shift + cmd - 7 : yabai -m window --space 2
      shift + cmd - 8 : yabai -m window --space 3
      shift + cmd - 9 : yabai -m window --space 4
      shift + cmd - 0 : yabai -m window --space 5

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
      "cormacrelf/tap"
    ];
    brews = [
      "mkcert"
      "nss"
      "azcopy"
      "dark-notify"
    ];
    casks = [
      "ghostty"
      "bruno"
      "google-chrome"
      "jordanbaird-ice"
      "missive"
      "raycast"
      "slack"
      "spaceman"
      "spotify"
      "tableplus"
      "headlamp"
      "obsidian"
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
