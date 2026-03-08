{ config, pkgs, ... }:
{
  imports = [
    ../shared/bat.nix
    ../shared/git.nix
  ];

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  programs.home-manager.enable = true;

  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "24.05";

  home.file.".termux/font.ttf".source =
    "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";

  home.packages = with pkgs; [
    openssh
    nerd-fonts.jetbrains-mono
    neovim
    ripgrep
    fzf
    jq
    unzip
  ];
}
