{ pkgs, ... }:
{
  home.packages = with pkgs; [
    k9s
    kubectl
    kubectx
    kustomize
    kubernetes-helm
    fluxcd
    sops
    age
  ];
}

