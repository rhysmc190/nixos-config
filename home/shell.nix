{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      claude = "claude --dangerously-skip-permissions";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      tree = "eza --tree";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
      directory.truncation_length = 5;
      cmd_duration.min_time = 2000;
      nix_shell.format = "via [$symbol$state]($style) ";
    };
  };
}
