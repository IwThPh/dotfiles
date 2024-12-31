{ config, pkgs, ... }:

{
  home.username = "iwanp";
  home.homeDirectory = "/Users/iwanp";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # Utils
    btop
    fzf
    jq
    ripgrep
    unzip
    # xq
    yq
    filezilla

    # Lang / Runtimes
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
      sdk_9_0
      runtime_6_0
      runtime_8_0
      runtime_9_0
    ])
    go
    lua
    mono
    nodejs_22
    rustup
    # azure-cli
    terraform
    tree-sitter

    # Docker
    docker
    docker-buildx
    docker-compose
    colima # colima start --cpu 4 --memory 8 --arch aarch64 --vm-type=vz --vz-rosetta

    # Programs
    alacritty
    bruno
    cmake
    k6
    jetbrains.rider
    lazydocker
    lazygit
    mtr
    neovim
    zellij
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
