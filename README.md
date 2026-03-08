# Dotfiles

Multi-platform dotfiles managed with [Nix](https://nixos.org/) ([nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager)) and [GNU Stow](https://www.gnu.org/software/stow/).

Supports three platforms:

| Host        | System           | Description                                                |
| ----------- | ---------------- | ---------------------------------------------------------- |
| `iwanp-ski` | `aarch64-darwin` | macOS (Apple Silicon) - full dev environment with GUI apps |
| `iwanp-dsk` | `x86_64-linux`   | Windows WSL - full dev, no GUI apps                        |
| `iwanp-s23` | `aarch64-linux`  | Nix-on-Droid - minimal CLI (SSH jump box + light editing)  |

## Setup

### Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled

### macOS

```bash
git clone git@github.com:IwThPh/dotfiles.git ~/dotfiles

# Build and switch
darwin-rebuild switch --flake ~/dotfiles/nix
```

### WSL (Windows)

```bash
# 1. Install WSL 2 (from PowerShell)
#    wsl --install

# 2. Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# 3. Enable flakes
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# 4. Clone and apply
git clone git@github.com:IwThPh/dotfiles.git ~/dotfiles
nix run home-manager/release-25.11 -- switch --flake ~/dotfiles/nix#iwanp-dsk
```

On subsequent rebuilds:

```bash
home-manager switch --flake ~/dotfiles/nix#iwanp-dsk
```

### Android (Nix-on-Droid)

```bash
# 1. Install Nix-on-Droid from F-Droid
#    https://github.com/nix-community/nix-on-droid

# 2. Clone and apply
git clone git@github.com:IwThPh/dotfiles.git ~/dotfiles
nix run home-manager/release-25.11 -- switch --flake ~/dotfiles/nix#iwanp-s23
```

On subsequent rebuilds:

```bash
home-manager switch --flake ~/dotfiles/nix#iwanp-s23
```

## Stow

App-specific dotfile configs structured to mirror `$HOME`. Stow can be used independently to symlink any of the packages below without Nix. When using nix-darwin or home-manager, symlinking is handled automatically via `home.file`.

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
