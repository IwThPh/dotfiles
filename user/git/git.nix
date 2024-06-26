{ pkgs, lib, userSettings, ... }:

{
  home.packages = with pkgs; [ git ];
 
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        name = userSettings.name;
        email = userSettings.email;
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
