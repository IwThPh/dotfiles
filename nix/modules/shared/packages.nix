{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Utils
    bat
    btop
    fzf
    jq
    ripgrep
    unzip
    yq
    grpcurl

    # Lang / Runtimes
    go
    lua51Packages.lua
    lua51Packages.luasql-sqlite3
    lua51Packages.sqlite
    nodejs_22
    yarn
    tree-sitter

    # Programs
    powershell
    gh
    azure-cli
    bws
    doctl
    doppler
    duckdb
    google-cloud-sdk
    cmake
    k6
    neovim
    sqlite
    terraform
    yamllint
    zellij
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
  };
}
