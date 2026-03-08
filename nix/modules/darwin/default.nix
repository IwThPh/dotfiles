{ pkgs, ... }:
{
  imports = [
    ../shared
    ./home.nix
    ./docker.nix
  ];

  home.packages = with pkgs; [
    jetbrains.rider
    jetbrains.rust-rover
  ];

  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";
}
