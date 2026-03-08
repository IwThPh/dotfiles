{
  description = "iwthph's multi-platform configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      insecurePackages = [
        "dotnet-combined"
        "dotnet-core-combined"
        "dotnet-runtime-6.0.36"
        "dotnet-runtime-wrapped-6.0.36"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
        "aspnetcore-runtime-6.0.36"
        "dotnet-wrapped-combined"
        "dotnet-runtime-7.0.20"
        "dotnet-runtime-wrapped-7.0.20"
        "dotnet-sdk-7.0.410"
        "dotnet-sdk-wrapped-7.0.410"
        "aspnetcore-runtime-7.0.20"
      ];
    in
    {
      darwinConfigurations = {
        iwanp-ski = darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";

          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
            config.permittedInsecurePackages = insecurePackages;
          };

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/iwanp-ski.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.iwanp = { imports = [ ./modules/darwin ]; };
            }
          ];
        };
      };

      homeConfigurations = {
        iwanp-dsk = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.permittedInsecurePackages = insecurePackages;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./modules/linux ];
        };

        iwanp-s23 = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./modules/android ];
        };
      };
    };
}
