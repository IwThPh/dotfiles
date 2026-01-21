{ pkgs, pkgs-ners, ... }:
let
  # Merge all SDKs/runtimes into one env and ignore file collisions.
  dotnetCombined = pkgs.buildEnv {
    name = "dotnet-combined";
    paths = with pkgs; [
      mono
      (with dotnetCorePackages; combinePackages [
        dotnet-sdk_6
        dotnet-runtime_6
        dotnet-aspnetcore_6
        dotnet-sdk_7
        dotnet-runtime_7
        dotnet-aspnetcore_7
        dotnet_8.runtime
        dotnet_8.sdk
        dotnet_8.aspnetcore
        dotnet_9.runtime
        dotnet_9.sdk
        dotnet_9.aspnetcore
        dotnet_10.runtime
        dotnet_10.sdk
        dotnet_10.aspnetcore
      ])
    ];
    ignoreCollisions = true;
  };
in
{
  home.packages = with pkgs; [
    dotnetCombined
    jetbrains.rider
  ];

  # Point tools at the newest SDK so the host/runtime resolver behaves as expected.
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.dotnet_9.sdk}/share/dotnet";
  };
}
