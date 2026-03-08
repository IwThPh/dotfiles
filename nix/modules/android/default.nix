{ config, pkgs, ... }:
{
  imports = [
    ../shared/bat.nix
    ../shared/git.nix
  ];

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  programs.home-manager.enable = true;

  home.username = "iwanp";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    neovim
    ripgrep
    fzf
    jq
    zellij
    unzip
  ];
}
