{ config, ... }:

let
  claudeConfigPath = "${config.home.homeDirectory}/dotfiles/stow/claude/.claude";
in
{
  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.zshrc";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zsh/.config/zsh";
    # ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/nvim/.config/nvim";
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/alacritty/.config/alacritty";
    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/zellij/.config/zellij";
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/.ideavimrc";
    ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/CLAUDE.md";
    ".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/settings.json";
    ".claude/policy-limits.json".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/policy-limits.json";
    ".claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/agents";
    ".claude/skills/commit".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/skills/commit";
    ".claude/skills/jot".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/skills/jot";
    ".claude/skills/review".source = config.lib.file.mkOutOfStoreSymlink "${claudeConfigPath}/skills/review";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
}
