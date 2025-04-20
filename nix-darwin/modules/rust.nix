{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
    cargo-audit
    cargo-outdated
    cargo-update
    cargo-watch
    cargo-binutils
    # cargo-llvm-cov -- broken, installing manually via cargo. `cargo install cargo-llvm-cov`

    # cargo
    # rust-analyzer

    rustc
    rustc.llvmPackages.llvm
    lld

    jetbrains.rust-rover
  ];
}

