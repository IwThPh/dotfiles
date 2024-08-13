{ pkgs, ... }:

pkgs.mkShell
{
  nativeBuildInputs = with pkgs; [
    php83
    php83Packages.composer
    nodejs
  ];

  shellHook = ''
    echo "Laravel Shell";
    echo PHP: $(${pkgs.php}/bin/php --version)
    echo Composer: $(${pkgs.php83Packages.composer}/bin/composer --version)
    echo NodeJS: $(${pkgs.nodejs}/bin/node --version)
  '';
}
