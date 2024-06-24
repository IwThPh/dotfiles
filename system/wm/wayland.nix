{ config, pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [ 
    wayland
    libsForQt5.qt5.qtgraphicaleffects #required for sddm theme sugar candy
  ];

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = pkgs.sddm;
      theme = "${import ./sddm.nix { inherit pkgs; }}";
  };
}

