{ lib, pkgs, ... }:

{
  nix.package = lib.mkForce pkgs.nixVersions.latest;

  nix.settings.trusted-users = [
    "root"
    "iwanp"
  ];

  nix.settings = {
    use-xdg-base-directories = true;
    experimental-features = "nix-command flakes";
    auto-optimise-store = false;

    allowed-users = [ "@wheel" "nix-serve" ];
    always-allow-substitutes = true;
    substituters = [
      "https://cache.nixos.org/"
    ];
  };
}
