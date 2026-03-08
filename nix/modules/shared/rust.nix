{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
    cargo-audit
    cargo-outdated
    #cargo-update
    cargo-watch
    cargo-binutils

    rustc
    rustc.llvmPackages.llvm
    lld
  ];
}
