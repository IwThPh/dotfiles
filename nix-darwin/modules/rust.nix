{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # rustup
    rust-analyzer
    cargo
    cargo-audit
    cargo-outdated
    cargo-update
    cargo-watch
    # lld
    # cargo-binutils
    # rustc.llvmPackages.llvm
    rustc
    # rustup

    jetbrains.rust-rover
  ];
}

