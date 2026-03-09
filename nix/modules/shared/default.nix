{ config, ... }:
{
  imports = [
    ./bat.nix
    ./git.nix
    ./packages.nix
    ./kubernetes.nix
    ./dotnet.nix
    ./rust.nix
    ./starship.nix
  ];

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  programs.home-manager.enable = true;
}
