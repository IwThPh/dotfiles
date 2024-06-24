{
  description = "IwThPh's Flake";

  outputs = inputs@{ self, ... }:
    let
      lib = inputs.nixpkgs.lib;

      home-manager = inputs.home-manager;

      pkgs = (import inputs.nixpkgs {
        system = systemSettings.system; 
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      });
      
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        system = systemSettings.system; 
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      });

      systemSettings = {
        system = "x86_64-linux";
        hostname = "iwanp-ski";
        profile = "personal";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        bootMode = "uefi";
        bootMountPath = "/boot";
      };

      userSettings = rec {
        username = "iwanp";
        name = "Iwan";
        email = "iwan@iwanphillips.dev";
        dotfilesDir = "~/dotfiles";
        wm = "hyprland";
        wmType = "wayland";
        theme = "emil";
        browser = "brave";
        term = "alacritty";
        font = "BlexMono Nerd Font Mono";
        fontPkg = pkgs.nerdfonts;
        editor = "nvim";
        spawnEditor = "exec " + term + " -e " + editor;
      };
    in
    {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];

          extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        iwanp = lib.nixosSystem {
          system = systemSettings.system;

          modules = [
            # (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            ./profiles/personal/configuration.nix
          ];

          specialArgs = {
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };
}
