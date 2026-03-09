{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$git_state\n$character";
      add_newline = true;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };

      directory.truncation_length = 3;
      git_branch.format = "[$branch]($style) ";
      cmd_duration.min_time = 2000;

      # Cloud/DevOps
      kubernetes.disabled = false;
      aws.disabled = false;
      gcloud.disabled = false;
      nix_shell.disabled = false;
    };
  };
}
