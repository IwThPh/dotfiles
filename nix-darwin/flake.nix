{
  description = "Darwin Flake";

  inputs = {
    nixpkgs = {
      # url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
      url = "github:NixOS/nixpkgs";
    };
    nix-darwin = {
      # url = "/Users/iwanp/dev/nix-darwin";
      # url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-rosetta-builder }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      # TODO: investigate darwinConfig for flakes
      # environment.darwinConfig = "$HOME/dotfiles/nix-darwin/flake.nix"

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
        ];
      };

      nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = false;

        allowed-users = [ "@wheel" "nix-serve" ];
        always-allow-substitutes = true;
        substituters = [ 
          "https://cache.nixos.org/" 
        ];
        #extra-substituters = [
          #"https://nix-community.cachix.org/"
          #"https://cache.nixos.org/"
          #"https://devenv.cachix.org/"
          #"https://cosmic.cachix.org/"
        #];
      };

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 2d";
        interval = {
          Hour = 5;
          Minute = 0;
        };
      };

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
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

      security.pam.enableSudoTouchIdAuth = true;

      users.users.iwanp.home = "/Users/iwanp";
      home-manager.backupFileExtension = "backup";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      services.yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;
        config = {
          mouse_follows_focus       =  "on";
          focus_follows_mouse       =  "off";
          window_origin_display     =  "default";
          window_shadow             =  "float";
          window_animation_duration =  "0.25";
          window_animation_easing   =  "ease_out_quint";
          window_opacity_duration   =  "0.2";
          active_window_opacity     =  "1.0";
          normal_window_opacity     =  "0.93";
          window_opacity            =  "on";
          insert_feedback_color     =  "0xffee5396";
          split_ratio               =  "0.62";
          split_type                =  "auto";
          auto_balance              =  "off";
          layout                    =  "bsp";
          mouse_modifier            =  "cmd";
          mouse_action1             =  "move";
          mouse_action2             =  "resize";
          mouse_drop_action         =  "swap";
          window_gap                =  "10";
          top_padding               =  "8";
          bottom_padding            =  "8";
          left_padding              =  "8";
          right_padding             =  "8";
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
          cmd - return : alacritty
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
          cmd - 1 : yabai -m display --focus $(yabai -m query --spaces --space 1 | jq .display) && yabai -m space --focus 1
          cmd - 2 : yabai -m display --focus $(yabai -m query --spaces --space 2 | jq .display) && yabai -m space --focus 2
          cmd - 3 : yabai -m display --focus $(yabai -m query --spaces --space 3 | jq .display) && yabai -m space --focus 3
          cmd - 4 : yabai -m display --focus $(yabai -m query --spaces --space 4 | jq .display) && yabai -m space --focus 4
          cmd - 5 : yabai -m display --focus $(yabai -m query --spaces --space 5 | jq .display) && yabai -m space --focus 5
          cmd - 6 : yabai -m display --focus $(yabai -m query --spaces --space 6 | jq .display) && yabai -m space --focus 6
          cmd - 7 : yabai -m display --focus $(yabai -m query --spaces --space 7 | jq .display) && yabai -m space --focus 7
          cmd - 8 : yabai -m display --focus $(yabai -m query --spaces --space 8 | jq .display) && yabai -m space --focus 8
          cmd - 9 : yabai -m display --focus $(yabai -m query --spaces --space 9 | jq .display) && yabai -m space --focus 9
          cmd - 0 : yabai -m display --focus $(yabai -m query --spaces --space 10 | jq .display) && yabai -m space --focus 10

          # Move window to space
          shift + cmd - 1 : yabai -m window --space 1
          shift + cmd - 2 : yabai -m window --space 2
          shift + cmd - 3 : yabai -m window --space 3
          shift + cmd - 4 : yabai -m window --space 4
          shift + cmd - 5 : yabai -m window --space 5
          shift + cmd - 6 : yabai -m window --space 6
          shift + cmd - 7 : yabai -m window --space 7
          shift + cmd - 8 : yabai -m window --space 8
          shift + cmd - 9 : yabai -m window --space 9
          shift + cmd - 0 : yabai -m window --space 10

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
          "postman"
          "spaceman"
          "jordanbaird-ice"
          "ghostty"
          "google-chrome"
          "firefox"
          "raycast"
          "spotify"
          "slack"
        ];
        masApps = {};
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


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = pkgs.hostPlatform.system ;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."iwanp-ski" = nix-darwin.lib.darwinSystem {
      system = [ "aarch64-darwin" ];
      pkgs = import nixpkgs { 
        system = "aarch64-darwin";
        config.allowUnfree = true; 
        config.permittedInsecurePackages = [
          "dotnet-combined"
          "dotnet-core-combined"
          "dotnet-runtime-6.0.36"
          "dotnet-runtime-wrapped-6.0.36"
          "dotnet-sdk-6.0.428"
          "dotnet-sdk-wrapped-6.0.428"
          "dotnet-wrapped-combined"
        ];
      };

      modules = [ 
        configuration 
        home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.iwanp = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."iwanp-ski".pkgs;
  };
}
