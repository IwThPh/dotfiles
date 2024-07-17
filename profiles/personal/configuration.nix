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
      ( import ../../system/app/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
      ../../system/style/stylix.nix
    ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.kernelModules = [ "cpufreq_powersave" ];
  boot.kernelPackages = pkgs.linuxPackages_6_9;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances"= 1024;
    "fs.inotify.max_user_watches"= 1048576;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath;

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "cofeportal.local"
      "cms.cofeportal.local"
      "cmsapi.cofeportal.local"
      "changemydetails.cofeportal.local"
      "mail.cofeportal.local"

      "heidi.local"
      "jura.heidi.local"
      "maude.heidi.local"
      "my-booking.heidi.local"
    ];
  };

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

  # Enable nix ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    curl
    glib
    stdenv.cc.cc
  ];

  environment.systemPackages = with pkgs; [
    bitwarden-cli
    fd
    fzf
    git
    home-manager
    (pkgs-unstable.rust-bin.stable.latest.default)
    pkgs-unstable.neovim
    tree-sitter
    ripgrep
    wget
    wpa_supplicant
    unzip
    zig
  ];

  environment.sessionVariables.NIXOS_OZONE_WL=1;

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal
    ];
  };

  nix.settings.auto-optimise-store = true;

  # It is ok to leave this unchanged for compatibility.
  system.stateVersion = "24.05";
}
