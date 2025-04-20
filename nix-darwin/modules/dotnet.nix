{ pkgs, pkgs-ners, ... }:
{
  home.packages = with pkgs; [
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
    ])

    jetbrains.rider
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
  };
}
