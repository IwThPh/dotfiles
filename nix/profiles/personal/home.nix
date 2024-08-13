{ config, pkgs, pkgs-unstable, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    # (./. + "../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
    ../../user/wm/hyprland/hyprland.nix
    # ../../user/shell/sh.nix
    ../../user/git/git.nix
    ../../user/style/stylix.nix
    # ../../user/shell/devshells.nix
  ];

  home.packages = with pkgs; [
    #bitwarden # this is ontop of the BW CLI in system
    (pkgs.vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    }))
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
      runtime_6_0
      runtime_8_0
    ])
    #gh
    #lua5_1 # neovim runs with lua 5.1 and luajit. Required for treesitter parsers and neorg
    #luajitPackages.luarocks
    #nodejs
    #openvpn
    #discord
    yq
    #slack
    #postman
    #spotify
    #pkgs-unstable.bruno
    #(let 
      #extra-path = with pkgs; [
        #(with dotnetCorePackages; combinePackages [
          #sdk_6_0
          #sdk_8_0
          #runtime_6_0
          #runtime_8_0
        #])
        #dotnetPackages.Nuget
        #mono
        #msbuild
      #];
      #extra-lib = with pkgs;[
      #];
      #rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
        #postInstall = ''
          ## Wrap rider with extra tools and libraries
          ##mv $out/bin/rider $out/bin/.rider-toolless
          #makeWrapper $out/bin/.rider-toolless $out/bin/rider \
            #--argv0 rider \
            #--prefix PATH : "${lib.makeBinPath extra-path}" \
            #--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"
#
          ## Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
          #shopt -s extglob
          #ln -s $out/rider/!(bin) $out/
          #shopt -u extglob
        #'' + attrs.postInstall or "";
      #});
    #in 
      #rider
    #)
    #beekeeper-studio
    #lazydocker
    #lazygit
    #syncthing
    zsh
    (pkgs.writeScriptBin "zcc" ''
      #!/bin/sh
      ${pkgs.zig}/bin/zig cc $@
    '')
  ];

  programs.k9s.enable = true;
  programs.zellij.enable = true;

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker="zcc"
  '';

  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
  };

  #programs.go.enable = true;

  #services.syncthing.enable = true;
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
    DOTNET_ROOT = pkgs.dotnet-sdk;
    #NIXOS_OZONE_WL=1;
  };

  home.stateVersion = "24.05";
}
