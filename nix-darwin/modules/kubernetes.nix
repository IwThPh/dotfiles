{ pkgs, ... }:
{
  home.packages = with pkgs; [
    k9s
    kubectl
    fluxcd
  ];
}

