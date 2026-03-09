{ config, pkgs, ... }:
{
  imports = [
    ../shared/bat.nix
    ../shared/git.nix
    ../shared/starship.nix
  ];

  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  programs.home-manager.enable = true;

  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "24.05";

  home.activation.termuxFont = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    install -Dm644 "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf" "$HOME/.termux/font.ttf"
  '';

  home.sessionVariables.LANG = "C.UTF-8";

  programs.starship = {
    enableZshIntegration = false;
    settings = {
      format = "$directory$git_branch$git_status$cmd_duration$character";
      right_format = "";
    };
  };

  home.file.".bashrc".text = ''
    eval "$(starship init bash)"

    # Auto-start syncthing if not already running
    if ! pgrep -x syncthing > /dev/null 2>&1; then
      syncthing serve --no-browser --no-restart > "$HOME/.local/share/syncthing.log" 2>&1 &
      disown
    fi
  '';

  home.packages = with pkgs; [
    openssh
    nerd-fonts.jetbrains-mono
    neovim
    ripgrep
    fzf
    jq
    unzip
    syncthing
  ];
}
