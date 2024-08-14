{
  description = "Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      environment.systemPackages = with pkgs; [ 
        vim
      ];


      nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;

        allowed-users = [ "@wheel" "nix-serve" ];
        
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
      services.nix-daemon.enable = true;
      nix.configureBuildUsers = true;
      nix.useDaemon = true;


      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      services.skhd.enable = true;
      services.yabai = {
        enable = true;
        enableScriptingAddition = true;
      };

      homebrew = {
        enable = true;
        global = {
          brewfile = true;
        };
        taps = [
          "homebrew/bundle" 
          "homebrew/homebrew-core" 
          "homebrew/homebrew-cask" 
        ];
        brews = [
          "jordanbaird-ice"
        ];
        casks = [
          "firefox"
          "raycast"
          "spotify"
          "slack"
        ];
        masApps = {};
      };

      fonts = {
        packages = [
          ( pkgs.nerdfonts.override {
            fonts = [
              "IBMPlexMono"
              "JetBrainsMono"
              "Meslo"
            ];
          })
        ];
      };


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."iwanp-ski" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { 
        system = "aarch64-darwin";
        config.allowUnfree = true; 
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
