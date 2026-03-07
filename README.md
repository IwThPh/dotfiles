# Dotfiles

macOS (Apple Silicon) dotfiles managed with [nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) and [GNU Stow](https://www.gnu.org/software/stow/).

## nix-darwin

Primary system and package management. Handles macOS defaults, Homebrew casks, yabai, skhd, fonts, and user packages.

### Prerequisites

- [Nix](https://nixos.org/download/)

### Usage

```bash
git clone git@github.com:IwThPh/dotfiles.git ~/dotfiles

# Rebuild and switch
darwin-rebuild switch --flake ~/dotfiles/nix-darwin
```

## Stow

App-specific dotfile configs structured to mirror `$HOME`. Stow can be used independently to symlink any of the packages below without nix. If using nix-darwin, home-manager handles the symlinking instead (see `nix-darwin/modules/home.nix`).

### Packages

alacritty, fuzzel, hypr, kitty, nvim (git submodule), spacebar, waybar, zellij, zsh

### Usage

```bash
cd ~/dotfiles/stow

# Stow a single package
stow -t ~ <package>

# Stow all packages
stow -t ~ *
```
