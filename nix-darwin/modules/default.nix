{ config, ... }:

let
  modules = [
    ./bat.nix
    ./git.nix
    ./home.nix
    ./kubernetes.nix
    ./dotnet.nix
    ./docker.nix
    ./latex.nix
    ./rust.nix
  ];
in
{
  imports = modules;
  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  programs.home-manager.enable = true;
  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";
}
