{ ... }:
{
  imports = [
    ../shared
    ./home.nix
    ./docker.nix
  ];

  home.username = "iwanp";
  home.homeDirectory = "/home/iwanp";
  home.stateVersion = "24.05";
}
