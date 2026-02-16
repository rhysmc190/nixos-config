{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      theme = "TokyoNight Storm";
      background-opacity = "0.95";
      background-blur = "true";
    };
  };
}
