{ config, pkgs, ... }:

{
  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    alacritty
    bitwarden-cli
    btop
    fzf
    go
    jq
    lua
    neovim
    ripgrep
    terraform
    tree-sitter
    unzip
    yq
    zellij
    nodejs_22
    rustup


    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
      runtime_6_0
      runtime_8_0
    ])
    jetbrains.rider
  ];

  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.zshrc";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.p10k.zsh";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.config/zsh";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/nvim/.config/nvim";
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/alacritty/.config/alacritty";
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zellij/.config/zellij";
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/.ideavimrc";
  };

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
  };
}
