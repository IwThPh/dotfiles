{ config, ... }:

{
  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.zshrc";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.p10k.zsh";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.config/zsh";
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zellij/.config/zellij";
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
  ];
}
