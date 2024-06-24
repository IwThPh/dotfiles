{ inputs, pkgs, lib, ... }:

{
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  # security = {
  #   pam.gnome.gnome-keyring.enable = true;
  # };
  #
  # services.gnome.gnome-keyring.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

  # programs = {
  #   hyprland = {
  #     enabled = true;
  #     package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #     xwayland.enable = true;
  #     portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
  #   };
  # };
}

