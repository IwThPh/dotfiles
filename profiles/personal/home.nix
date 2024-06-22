{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zsh
    alacritty
    brave
    git
    syncthing
  ];

  xdg.enable = true;

  home.stateVersion = "24.05";
}
