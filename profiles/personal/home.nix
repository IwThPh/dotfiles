{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    # (./. + "../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
    ../../user/wm/hyprland/hyprland.nix
    # ../../user/shell/sh.nix
    ../../user/git/git.nix
    ../../user/style/stylix.nix
  ];

  home.packages = with pkgs; [
    alacritty
    bitwarden # this is ontop of the BW CLI in system
    brave
    git
    gnumake
    lua
    luajitPackages.luarocks
    nodejs
    openvpn
    php
    slack
    spotify
    jetbrains.rider
    syncthing
    zsh
  ];

  programs.k9s.enable = true;
  programs.zellij.enable = true;

  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
  };

  programs.go.enable = true;

  services.syncthing.enable = true;
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  home.stateVersion = "24.05";
}
