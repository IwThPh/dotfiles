{ ... }:
{
  imports = [
    ../shared
    ./home.nix
    ./docker.nix
    ./k3s.nix
  ];

  home.username = "iwanp";
  home.homeDirectory = "/home/iwanp";
  home.stateVersion = "24.05";
}
