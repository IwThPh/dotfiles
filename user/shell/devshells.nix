{ pkgs, ... }:
let
  laravel = (import ./laravel.nix { inherit pkgs; });
in
{
  environment.systemPackages = [
    (pkgs.writeScriptBin "zsh-laravel8_3" ''${pkgs.zsh} --init-file ${laravel}'' )
  ];
}
