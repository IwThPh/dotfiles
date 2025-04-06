{ config, ... }:

let
  modules = [
    ./bat.nix
    ./nix.nix
    ./git.nix
    ./home.nix
  ];
in
{
  imports = modules;
  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  programs.home-manager.enable = true;
  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";
}
