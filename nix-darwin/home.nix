{ config, pkgs, ... }:

{
  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";

  home.packages = [];

  home.file = {
  };

  home.sessionVariables = {
  };

  home.sessionPath = {
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  };
  
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
  };
}
