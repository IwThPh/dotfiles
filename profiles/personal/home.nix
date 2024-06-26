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
    btop
    (pkgs.vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    }))
    git
    gnumake
    lua5_1 # neovim runs with lua 5.1 and luajit. Required for treesitter parsers and neorg
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
