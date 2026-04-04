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
    nixfmt

    # Lang / Runtimes
    go
    lua51Packages.lua
    lua51Packages.luasql-sqlite3
    lua51Packages.sqlite
    nodejs_22
    yarn
    tree-sitter

    # Programs
    azure-cli
    bitwarden-cli
    claude-code
    cmake
    doctl
    doppler
    duckdb
    gh
    google-cloud-sdk
    k6
    neovim
    powershell
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
