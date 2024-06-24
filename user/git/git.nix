{ pkgs, lib, userSettings, ... }:

{
  home.packages = with pkgs; [ git ];
 
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        name = "Iwan Phillips";
        email = "iwan@iwanphillips.dev";
      };
      checkout = {
        defaultRemote = "origin";
        guess = true;
      };
      init.defaultBranch = "main";
      branch.autoSetupRebase = "always";
      push.autoSetupRemote = true;
      include.path = "/home/" + userSettings.username + "/.gituser";
    };

    delta.enable = true;
    lfs.enable = true;
  };
}
