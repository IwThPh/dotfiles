{
  description = "Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
        pkgs.vim
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

      services.nix-daemon.enable = true;

      system.defaults.NSGlobalDomain = {
        InitialKeyRepeat = 24; #units are 15ms, 500ms
        KeyRepeat = 1; #units are 15ms, 15ms
        NSDocumentSaveNewDocumentsToCloud = false;
      };

      security.pam.enableSudoTouchIdAuth = true;



      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      homebrew = {
        enable = true;
        global = {
          brewfile = true;
        };
        taps = ["homebrew/bundle" "homebrew/cask" "homebrew/core"];
        brews = [];
        casks = [
          "firefox"
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
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."iwanp-ski".pkgs;
  };
}
