# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, systemSettings, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      (./. + "../../system/wm" + ("/" + userSettings.wm) + ".nix")
    ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnFree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
    uid = 1000;
  };


  environment.systemPackages = with pkgs; [
    git
    home-manager
    vim
    wget
    wpa_supplicant
    zig
  ];


  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # It is ok to leave this unchanged for compatibility.
  system.stateVersion = "24.05";
}
