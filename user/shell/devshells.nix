{ pkgs, ... }:
let
  laravel = (import ./laravel8_3.nix { inherit pkgs; });
in
{
  home.packages = [
    (pkgs.writeScriptBin "zsh-laravel-php8-3" ''
      nix-shell --shell ${pkgs.zsh}/bin/zsh --init-file ${laravel}
    '' )
  ];
}
