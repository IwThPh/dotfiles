{ config, pkgs, ... }:
{
  imports = [
    ../shared/bat.nix
    ../shared/git.nix
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
    enable = true;
    enableBashIntegration = false;
    settings = {
      format = "$directory$git_branch$git_status$cmd_duration$character";
      directory.truncation_length = 3;
      git_branch.format = "[$branch]($style) ";
      cmd_duration.min_time = 2000;
    };
  };

  home.file.".bashrc".text = ''
    eval "$(starship init bash)"
  '';

  home.packages = with pkgs; [
    openssh
    nerd-fonts.jetbrains-mono
    neovim
    ripgrep
    fzf
    jq
    unzip
  ];
}
