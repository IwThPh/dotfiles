# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, pkgs-unstable, lib, systemSettings, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/hardware/bluetooth.nix
      ../../system/hardware/power.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/time.nix
      ../../system/hardware/thunderbolt.nix
      #("../../system/wm" + ("/" + userSettings.wm) + ".nix")
      ../../system/wm/hyprland.nix
      ../../system/style/stylix.nix
    ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.kernelModules = [ "cpufreq_powersave" ];
  boot.kernelPackages = pkgs.linuxPackages_6_9;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath;

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

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "password";
    uid = 1000;
    packages = [ ];
  };

  environment.systemPackages = with pkgs; [
    bitwarden-cli
    fd
    fzf
    git
    home-manager
    pkgs-unstable.neovim
    ripgrep
    wget
    wpa_supplicant
    unzip
    zig
  ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  # It is ok to leave this unchanged for compatibility.
  system.stateVersion = "24.05";
}
