{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      theme = "TokyoNight Storm";
      background-opacity = "0.95";
      background-blur = "true";
    };
  };
}
