{ lib, pkgs, inputs, userSettings, ... }:

let
  themePath = "../../../themes"+("/"+userSettings.theme+"/"+userSettings.theme)+".yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/polarity.txt"));
  backgroundUrl = builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/backgroundurl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../themes/"+("/"+userSettings.theme)+"/backgroundsha256.txt");
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = ./. + themePath;

  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    serif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    sansSerif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-monochrome-emoji;
    };
  };

  stylix.targets.console.enable = true;
}
