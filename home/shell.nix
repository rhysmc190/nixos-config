{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab + "/share/fzf-tab";
      }
    ];
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      cat = "bat";
      claude = "claude --dangerously-skip-permissions";
      df = "duf";
      du = "dust";
      htop = "btop";
      ps = "procs";
      la = "eza -la";
      ll = "eza -l";
      ls = "eza";
      tree = "eza --tree";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "never";
      style = "numbers,changes";
    };
    extraPackages = with pkgs; [ bat-extras.batman ];
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
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
