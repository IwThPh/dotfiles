{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    k9s
    kubectl
    kubectx
    kustomize
    kubernetes-helm
    pkgs-unstable.talosctl
    fluxcd
    sops
    age
  ];
}
