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

    # Lang / Runtimes
    (with dotnetCorePackages; combinePackages [
      dotnet-sdk_6
      dotnet-runtime_6
      dotnet-aspnetcore_6
      dotnet_8.runtime
      dotnet_8.sdk
      dotnet_8.aspnetcore
      dotnet_9.runtime
      dotnet_9.sdk
      dotnet_9.aspnetcore
    ])
    go
    sqlite
    lua51Packages.lua
    lua51Packages.sqlite
    lua51Packages.luasql-sqlite3
    mono
    nodejs_22
    rustup
    azure-cli
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
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
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
