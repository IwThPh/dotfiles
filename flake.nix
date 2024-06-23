{
  description = "IwThPh's Flake";

  outputs = inputs@{ self, ... }:
    let
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
        browser = "brave";
        term = "alacritty";
        font = "IBM Blex Mono";
        fontPkg = pkgs.nerd-fonts;
        editor = "nvim";
        spawnEditor = "exec " + term + " -e " + editor;
      };

      pkgs = (import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnFree = true;
          allowUnFreePredicate = (_: true);
        };
        overlays = [ inputs.rust-overlay.overlays.default ];
      });

      lib = inputs.nixpkgs.lib;

      home-manager = inputs.home-manager;

    in
    {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];

          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;

          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          ];

          specialArgs = {
            inherit pkgs;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      rev = "ea2501d4556f84d3de86a4ae2f4b22a474555b9f";
    };
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };
}
