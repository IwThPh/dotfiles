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
        # Only supported on unstable currently
        # overlays = [ inputs.rust-overlay.overlays.default ]; 
      });
      
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        system = systemSettings.system; 
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [ inputs.rust-overlay.overlays.default ];
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
        name = "Iwan Phillips";
        email = "iwan@iwanphillips.dev";
        dotfilesDir = "~/dotfiles";
        wm = "hyprland";
        wmType = "wayland";
        theme = "carbonfox";
        browser = "vivaldi";
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
          modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") ];

          extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix") ];

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

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      rev = "4dd2b5902e770eeaf84820eccfebb5451aedb6a5";
    };
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hycov.url = "github:DreamMaoMao/hycov/6748bde85fa3a4f82cf8b038a6538f12f9f27428";
    hycov.inputs.hyprland.follows = "hyprland";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };
}
