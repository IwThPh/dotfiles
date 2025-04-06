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

          modules = [
            ./modules/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.iwanp = {
                imports = [
                  ./modules
                ];
              };
            }
          ];

          # pkgs = import nixpkgs {
          #   system = "aarch64-darwin";
          #   config.allowUnfree = true;
          #   config.permittedInsecurePackages = [
          #     "dotnet-combined"
          #     "dotnet-core-combined"
          #     "dotnet-runtime-6.0.36"
          #     "dotnet-runtime-wrapped-6.0.36"
          #     "dotnet-sdk-6.0.428"
          #     "dotnet-sdk-wrapped-6.0.428"
          #     "aspnetcore-runtime-6.0.36"
          #     "dotnet-wrapped-combined"
          #   ];
          # };

        };
      };
    };
}
