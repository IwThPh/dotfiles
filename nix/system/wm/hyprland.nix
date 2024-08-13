{ inputs, pkgs, ... }: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  environment = {
    plasma5.excludePackages = [ pkgs.kdePackages.systemsettings ];
    plasma6.excludePackages = [ pkgs.kdePackages.systemsettings ];
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
}

