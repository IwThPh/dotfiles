{ pkgs, lib, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "iwanp";
    wslConf.automount.root = "/mnt";
    wslConf.boot.systemd = true;
    interop.includePath = true;
    interop.register = true;
  };

  system.stateVersion = "25.11";
  networking.hostName = "iwanp-dsk";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root" "iwanp" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  users.users.iwanp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=0644"
      "--disable=traefik"
      "--disable=servicelb"
    ];
  };

  # Don't auto-start k3s on boot — start manually with: sudo systemctl start k3s
  systemd.services.k3s.wantedBy = lib.mkForce [];

  services.syncthing = {
    enable = true;
    user = "iwanp";
    dataDir = "/home/iwanp";
    openDefaultPorts = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];
}
