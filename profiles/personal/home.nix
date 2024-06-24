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
    zsh
    alacritty
    brave
    git
    syncthing
    openvpn
    slack
    spotify
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

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
