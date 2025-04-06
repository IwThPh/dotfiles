{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pandoc
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-tetex framed;
    })
  ];
}

