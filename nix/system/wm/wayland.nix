{ lib, config, pkgs, userSettings, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [ 
    wayland
  ];
}

