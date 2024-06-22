{ config, pkgs, ... }:

{
  imports = [ 
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs;
    [
      wayland waydroid
    ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "gb";
      variant = "";
      options = "ctrl:nocaps";
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = pkgs.sddm;
    }
  }
}

