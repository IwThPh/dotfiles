{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    config = {
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
  };
}

