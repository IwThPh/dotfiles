{ inputs, pkgs, lib, ... }: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ 
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  security = {
    pam.gnome.gnome-keyring.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enabled = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  # services.xserver.excludePacakges = [pkgs.xterm];
}

