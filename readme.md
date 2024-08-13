# Dotfiles

Collection of dotfiles in the form of GNU Stow modules and an experimental NixOS configuration.

## Stow

### Prerequisites

- [Git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)

#### Install on MacOS (with [Homebrew](https://brew.sh/))
```bash
brew install git stow
```

#### Install on Ubuntu
```bash
sudo apt install git stow
```

### Installation

```bash
git clone github.com/IwThPh/dotfiles.git ~/dotfiles

cd ~/dotfiles/stow

# Stow all packages, target directory is the home directory
stow -t ~ *
```

## NixOS

Experimental config that is likely broken.
To be revisited for potential HomeLab / Virtual Machine use.
