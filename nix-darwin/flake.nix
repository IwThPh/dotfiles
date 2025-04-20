{
  description = "iwthph's macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      system = "aarch64-darwin";

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
          inherit inputs system;

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = insecurePackages;
          };

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./modules/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.iwanp = { imports = [ ./modules ]; };
            }
          ];
        };
      };
    };
}
